# https://developers.home-assistant.io/docs/apps/configuration#app-dockerfile
# This app is based on the official Hermes Agent image (not on the Home
# Assistant base image), so it uses a plain shell entrypoint and jq to read the
# app options from /data/options.json.
ARG HERMES_VERSION=latest
FROM nousresearch/hermes-agent:${HERMES_VERSION}

USER root

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends jq git ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*

# Copy root filesystem
COPY rootfs /
RUN chmod a+x /run.sh

ENTRYPOINT ["/run.sh"]
CMD []

LABEL \
    io.hass.type="app" \
    org.opencontainers.image.title="Home Assistant App: Hermes Agent" \
    org.opencontainers.image.description="Hermes Agent by Nous Research with Git and persistent workspaces." \
    org.opencontainers.image.source="https://github.com/amiralbert/Amirs-HA-Apps" \
    org.opencontainers.image.licenses="MIT"
