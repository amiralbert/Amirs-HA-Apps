# https://developers.home-assistant.io/docs/apps/configuration#app-dockerfile
# Based on the LinuxServer.io Obsidian image (Obsidian in the browser).
# It brings its own s6-overlay (/init), hence "init: false" in config.yaml.
ARG OBSIDIAN_VERSION=latest
FROM lscr.io/linuxserver/obsidian:${OBSIDIAN_VERSION}

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends jq \
    && rm -rf /var/lib/apt/lists/*

# Copy root filesystem (custom-cont-init.d scripts run before the services)
COPY rootfs /
RUN chmod a+x /custom-cont-init.d/*.sh

LABEL \
    io.hass.type="app" \
    org.opencontainers.image.title="Home Assistant App: Obsidian" \
    org.opencontainers.image.description="Obsidian desktop in your browser, vault stored in /share/obsidian." \
    org.opencontainers.image.source="https://github.com/amiralbert/Amirs-HA-Apps" \
    org.opencontainers.image.licenses="MIT"
