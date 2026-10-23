# https://developers.home-assistant.io/docs/apps/configuration#app-dockerfile
# Tolaria is a desktop app (Tauri) without a server mode, so it runs inside the
# LinuxServer.io Selkies web desktop, the same base as the Obsidian app.
# The base image brings its own s6-overlay (/init), hence "init: false" in config.yaml.
FROM lscr.io/linuxserver/baseimage-selkies:debiantrixie

# Upstream only publishes a Linux build for amd64 (AppImage).
ARG TOLARIA_VERSION=2026.10.13

# desktop-file-utils and xdg-utils: Tolaria registers its tolaria:// link
# handler on startup and fails without update-desktop-database.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        desktop-file-utils \
        jq \
        openssl \
        xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Extract the AppImage so it runs without FUSE
RUN TAG="v$(echo "${TOLARIA_VERSION}" | tr '.' '-')" \
    && curl -fsSL -o /tmp/tolaria.AppImage \
        "https://github.com/refactoringhq/tolaria/releases/download/${TAG}/Tolaria_${TOLARIA_VERSION}_amd64.AppImage" \
    && chmod +x /tmp/tolaria.AppImage \
    && cd /tmp \
    && ./tolaria.AppImage --appimage-extract > /dev/null \
    && mv /tmp/squashfs-root /opt/tolaria \
    && chmod -R a+rX /opt/tolaria \
    && rm -f /tmp/tolaria.AppImage \
    && install -Dm644 /opt/tolaria/tolaria.png /usr/share/icons/hicolor/256x256/apps/tolaria.png

# WebKitGTK has no GPU and no user namespaces in an app container
ENV \
    TITLE="Tolaria" \
    WEBKIT_DISABLE_DMABUF_RENDERER=1 \
    WEBKIT_DISABLE_COMPOSITING_MODE=1

# Copy root filesystem (custom-cont-init.d scripts run before the services)
COPY rootfs /
RUN chmod a+x /custom-cont-init.d/*.sh /usr/bin/tolaria

LABEL \
    io.hass.type="app" \
    org.opencontainers.image.title="Home Assistant App: Tolaria" \
    org.opencontainers.image.description="Tolaria desktop in your browser, vault stored in /share/tolaria." \
    org.opencontainers.image.source="https://github.com/amiralbert/Amirs-HA-Apps" \
    org.opencontainers.image.licenses="MIT"
