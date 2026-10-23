# https://developers.home-assistant.io/docs/apps/configuration#app-dockerfile
# Tolaria is a desktop app (Tauri) without a server mode, so it runs inside the
# LinuxServer.io Selkies web desktop, the same base as the Obsidian app.
# The base image brings its own s6-overlay (/init), hence "init: false" in config.yaml.
ARG SELKIES_IMAGE=lscr.io/linuxserver/baseimage-selkies:debiantrixie

# ------------------------------------------------------------------------------
# Tolaria build: upstream publishes Linux builds for amd64 only, so amd64 uses
# the official AppImage and aarch64 builds the same release from source.
# ------------------------------------------------------------------------------
FROM ${SELKIES_IMAGE} AS tolaria

ARG TOLARIA_VERSION=2026.10.13
ARG NODE_VERSION=22.22.0
ARG PNPM_VERSION=10.34.7
# Set to "true" to build from source on amd64 too
ARG TOLARIA_FROM_SOURCE=false

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3003,DL3008
RUN set -e; \
    mkdir -p /out; \
    TAG="v${TOLARIA_VERSION//./-}"; \
    ARCH="$(dpkg --print-architecture)"; \
    if [[ "${ARCH}" == "amd64" && "${TOLARIA_FROM_SOURCE}" != "true" ]]; then \
        curl -fsSL -o /tmp/tolaria.AppImage \
            "https://github.com/refactoringhq/tolaria/releases/download/${TAG}/Tolaria_${TOLARIA_VERSION}_amd64.AppImage"; \
        chmod +x /tmp/tolaria.AppImage; \
        cd /out; \
        /tmp/tolaria.AppImage --appimage-extract > /dev/null; \
        exit 0; \
    fi; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        build-essential \
        file \
        git \
        jq \
        libayatana-appindicator3-dev \
        librsvg2-dev \
        libsoup-3.0-dev \
        libssl-dev \
        libwebkit2gtk-4.1-dev \
        libxdo-dev \
        pkg-config \
        xz-utils; \
    case "${ARCH}" in \
        amd64) NODE_ARCH=x64; RUST_TARGET=x86_64-unknown-linux-gnu ;; \
        arm64) NODE_ARCH=arm64; RUST_TARGET=aarch64-unknown-linux-gnu ;; \
        *) echo "Unsupported architecture: ${ARCH}" >&2; exit 1 ;; \
    esac; \
    curl -fsSL "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${NODE_ARCH}.tar.xz" \
        | tar -xJ -C /usr/local --strip-components=1; \
    npm install -g "pnpm@${PNPM_VERSION}"; \
    curl -fsSL -o /tmp/rustup-init "https://static.rust-lang.org/rustup/dist/${RUST_TARGET}/rustup-init"; \
    chmod +x /tmp/rustup-init; \
    /tmp/rustup-init -y --profile minimal --no-modify-path; \
    export PATH="/root/.cargo/bin:${PATH}"; \
    git clone --depth 1 --branch "${TAG}" https://github.com/refactoringhq/tolaria.git /src; \
    cd /src; \
    jq --arg v "${TOLARIA_VERSION}" '.version = $v' src-tauri/tauri.conf.json > /tmp/tauri.conf.json; \
    mv /tmp/tauri.conf.json src-tauri/tauri.conf.json; \
    sed -i "s/^version = \".*\"/version = \"${TOLARIA_VERSION}\"/" src-tauri/Cargo.toml; \
    pnpm install --frozen-lockfile; \
    export NODE_OPTIONS="--max-old-space-size=8192"; \
    pnpm tauri build --bundles deb --config '{"bundle":{"createUpdaterArtifacts":false}}'; \
    cp src-tauri/target/release/bundle/deb/*.deb /out/tolaria.deb

# ------------------------------------------------------------------------------
# App image
# ------------------------------------------------------------------------------
# hadolint ignore=DL3006
FROM ${SELKIES_IMAGE}

# desktop-file-utils and xdg-utils: Tolaria registers its tolaria:// link
# handler on startup and fails without update-desktop-database.
# /out holds either the extracted AppImage (squashfs-root) or a .deb package.
# hadolint ignore=DL3008
RUN --mount=type=bind,from=tolaria,source=/out,target=/tmp/tolaria \
    set -e; \
    apt-get update; \
    if [ -f /tmp/tolaria/tolaria.deb ]; then \
        apt-get install -y --no-install-recommends /tmp/tolaria/tolaria.deb; \
    else \
        cp -a /tmp/tolaria/squashfs-root /opt/tolaria; \
        chmod -R a+rX /opt/tolaria; \
        printf '#!/bin/sh\n# Start Tolaria from the extracted AppImage\nexec /opt/tolaria/AppRun "$@"\n' > /usr/bin/tolaria; \
        chmod a+x /usr/bin/tolaria; \
        install -Dm644 /opt/tolaria/tolaria.png /usr/share/icons/hicolor/256x256/apps/tolaria.png; \
    fi; \
    apt-get install -y --no-install-recommends \
        desktop-file-utils \
        jq \
        openssl \
        xdg-utils; \
    rm -rf /var/lib/apt/lists/*

# WebKitGTK has no GPU and no user namespaces in an app container
ENV \
    TITLE="Tolaria" \
    WEBKIT_DISABLE_DMABUF_RENDERER=1 \
    WEBKIT_DISABLE_COMPOSITING_MODE=1

# Copy root filesystem (custom-cont-init.d scripts run before the services)
COPY rootfs /
RUN chmod a+x /custom-cont-init.d/*.sh

LABEL \
    io.hass.type="app" \
    org.opencontainers.image.title="Home Assistant App: Tolaria" \
    org.opencontainers.image.description="Tolaria desktop in your browser, vault stored in /share/tolaria." \
    org.opencontainers.image.source="https://github.com/amiralbert/Amirs-HA-Apps" \
    org.opencontainers.image.licenses="MIT"
