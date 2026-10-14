# https://developers.home-assistant.io/docs/apps/configuration#app-dockerfile
ARG BUILD_FROM=ghcr.io/home-assistant/base:3.23
FROM ${BUILD_FROM}

# hadolint ignore=DL3018
RUN apk add --no-cache git openssh-client github-cli

# Copy root filesystem
COPY rootfs /
RUN chmod a+x /etc/s6-overlay/s6-rc.d/github-sync/run /etc/s6-overlay/s6-rc.d/github-sync/finish

LABEL \
    io.hass.type="addon" \
    org.opencontainers.image.title="Home Assistant App: GitHub Sync" \
    org.opencontainers.image.description="Keeps GitHub repositories in /share in sync." \
    org.opencontainers.image.source="https://github.com/amiralbert/Amirs-HA-Apps" \
    org.opencontainers.image.licenses="MIT"
