#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

export HOME=/config

PIDS=

notify() {
    for N in $(ls /etc/logmonitor/targets.d/*/send)
    do
       "$N" "$1" "$2" "$3" &
       PIDS="$PIDS $!"
    done
}

# Verify support for membarrier.
if ! /usr/bin/membarrier_check 2>/dev/null; then
   notify "$APP_NAME requires the membarrier system call." "$APP_NAME is likely to crash because it requires the membarrier system call.  See the documentation of this Docker container to find out how this system call can be allowed." "WARNING"
fi

# Wait for all PIDs to terminate.
set +e
for PID in "$PIDS"; do
   wait $PID
done
set -e

CHROME_ARGS="--no-sandbox --disable-dev-shm-usage --disable-gpu"

if [ "${CHROME_KIOSK:-0}" = "1" ]; then
    CHROME_ARGS="$CHROME_ARGS --kiosk"
fi

if [ -n "${CHROME_OPEN_URL:-}" ]; then
    CHROME_ARGS="$CHROME_ARGS $CHROME_OPEN_URL"
fi

if [ -n "${CHROME_CUSTOM_ARGS:-}" ]; then
    CHROME_ARGS="$CHROME_ARGS $CHROME_CUSTOM_ARGS"
fi

chromium --version
exec chromium $CHROME_ARGS --user-data-dir=/config/chrome-user-data "$@" >> /config/log/chrome/output.log 2>> /config/log/chrome/error.log

# vim:ft=sh:ts=4:sw=4:et:sts=4
