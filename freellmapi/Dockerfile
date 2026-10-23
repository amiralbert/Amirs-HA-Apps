# https://developers.home-assistant.io/docs/apps/configuration#app-dockerfile
ARG BUILD_FROM=ghcr.io/home-assistant/base:3.23
FROM ${BUILD_FROM}

# Branch or tag of https://github.com/tashfeenahmed/freellmapi to build
ARG FREELLMAPI_REF=main

# Build FreeLLMAPI from source. better-sqlite3 is a native module, so a
# toolchain is needed while building; it is removed again afterwards.
# hadolint ignore=DL3018
RUN apk add --no-cache nodejs npm \
    && apk add --no-cache --virtual .build-deps git python3 make g++ \
    && git clone --depth 1 --branch "${FREELLMAPI_REF}" \
        https://github.com/tashfeenahmed/freellmapi.git /app \
    && cd /app \
    && npm ci \
    && npm run build \
    && npm prune --omit=dev \
    && rm -rf /app/.git /root/.npm /tmp/* \
    && apk del .build-deps

# Copy root filesystem
COPY rootfs /
RUN chmod a+x /etc/s6-overlay/s6-rc.d/freellmapi/run /etc/s6-overlay/s6-rc.d/freellmapi/finish

WORKDIR /app

# Replaces the obsolete app watchdog
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD ["node", "-e", "fetch('http://127.0.0.1:3001/api/ping').then((r) => process.exit(r.ok ? 0 : 1), () => process.exit(1))"]

LABEL \
    io.hass.type="app" \
    org.opencontainers.image.title="Home Assistant App: FreeLLMAPI" \
    org.opencontainers.image.description="Local OpenAI-compatible gateway that stacks the free tiers of many LLM providers." \
    org.opencontainers.image.source="https://github.com/amiralbert/Amirs-HA-Apps" \
    org.opencontainers.image.licenses="MIT"
