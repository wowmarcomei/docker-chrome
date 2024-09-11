#!/bin/sh

set -e

PREF_FILE="${1:-/config/chrome-user-data/Default/Preferences}"

if [ -z "$PREF_FILE" ]; then
    echo "ERROR: Preference file not set."
    exit 1
fi

mkdir -p "$(dirname "$PREF_FILE")"
[ -f "$PREF_FILE" ] || echo '{}' > "$PREF_FILE"

# Ensure jq is installed
if ! command -v jq >/dev/null 2>&1; then
    echo "ERROR: jq is not installed. Cannot process Chrome preferences."
    exit 1
fi

set_nested_pref() {
    local pref="$1"
    local value="$2"
    local tmp_file="$PREF_FILE.tmp"

    if [ "$value" = "UNSET" ]; then
        echo "Removing preference '$pref'..."
        jq "del(.$pref)" "$PREF_FILE" > "$tmp_file" && mv "$tmp_file" "$PREF_FILE"
    else
        echo "Setting preference '$pref'..."
        jq ".$pref = $value" "$PREF_FILE" > "$tmp_file" && mv "$tmp_file" "$PREF_FILE"
    fi
}

env | grep "^CHROME_PREF_" | while read -r ENV
do
    ENAME="$(echo "$ENV" | cut -d '=' -f1)"
    EVAL="$(echo "$ENV" | cut -d '=' -f2-)"

    if [ -z "$EVAL" ]; then
        echo "Skipping environment variable '$ENAME': no value set."
        continue
    fi

    PNAME="$(echo "$EVAL" | cut -d '=' -f1)"
    PVAL="$(echo "$EVAL" | cut -d '=' -f2-)"

    if [ -z "$PVAL" ]; then
        echo "WARNING: Empty value for preference '$PNAME'. Skipping."
        continue
    fi

    set_nested_pref "$PNAME" "$PVAL"
done

echo "Chrome preferences have been updated."

# vim:ft=sh:ts=4:sw=4:et:sts=4
