# Chromium Dockerfile

# Build the membarrier check tool.
FROM alpine:3.14 AS membarrier
WORKDIR /tmp
COPY membarrier_check.c .
RUN apk --no-cache add build-base linux-headers
RUN gcc -static -o membarrier_check membarrier_check.c
RUN strip membarrier_check

# Pull base image.
FROM jlesage/baseimage-gui:alpine-3.20-v4.6.3

# Docker image version is provided via build arg.
ARG DOCKER_IMAGE_VERSION=

# Define working directory.
WORKDIR /tmp

# Install Chromium and dependencies
RUN \
    apk add --no-cache \
    chromium \
    chromium-chromedriver \
    wget \
    ca-certificates \
    libstdc++ \
    nss \
    freetype \
    harfbuzz \
    ttf-freefont \
    mesa-dri-gallium \
    libpulse \
    adwaita-icon-theme \
    font-dejavu \
    xdotool \
    jq

# Install necessary packages
RUN apk add --no-cache fontconfig wqy-zenhei

# Update font cache
RUN fc-cache -fv

# Set default language
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN:zh
ENV LC_ALL zh_CN.UTF-8

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://raw.githubusercontent.com/chromium/chromium/master/chrome/app/theme/chromium/product_logo_256.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Add files.
COPY rootfs/ /
COPY --from=membarrier /tmp/membarrier_check /usr/bin/

# Set internal environment variables.
RUN \
    set-cont-env APP_NAME "Chromium" && \
    set-cont-env APP_VERSION "$(chromium --version | cut -d ' ' -f 2)" && \
    set-cont-env DOCKER_IMAGE_VERSION "$DOCKER_IMAGE_VERSION" && \
    true

# Set public environment variables.
ENV \
    CHROMIUM_OPEN_URL= \
    CHROMIUM_KIOSK=0 \
    CHROMIUM_CUSTOM_ARGS=

# Metadata.
LABEL \
      org.label-schema.name="chromium" \
      org.label-schema.description="Docker container for Chromium" \
      org.label-schema.version="${DOCKER_IMAGE_VERSION:-unknown}" \
      org.label-schema.vcs-url="https://github.com/yourusername/docker-chromium" \
      org.label-schema.schema-version="1.0"
