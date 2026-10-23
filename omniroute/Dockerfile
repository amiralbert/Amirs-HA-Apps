# https://developers.home-assistant.io/docs/apps/configuration#app-dockerfile
# This app is based on the official OmniRoute image (not on the Home Assistant
# base image), so it uses a plain shell entrypoint and the bundled Node.js to
# read the app options from /data/options.json.
ARG OMNIROUTE_VERSION=3.8.52
FROM diegosouzapw/omniroute:${OMNIROUTE_VERSION}

USER root

# Copy root filesystem
COPY rootfs /
RUN chmod a+x /run.sh

WORKDIR /app

ENTRYPOINT ["/run.sh"]
CMD []

LABEL \
    io.hass.type="app" \
    org.opencontainers.image.title="Home Assistant App: OmniRoute" \
    org.opencontainers.image.description="Unified AI router with one OpenAI-compatible endpoint for many LLM providers." \
    org.opencontainers.image.source="https://github.com/amiralbert/Amirs-HA-Apps" \
    org.opencontainers.image.licenses="MIT"
