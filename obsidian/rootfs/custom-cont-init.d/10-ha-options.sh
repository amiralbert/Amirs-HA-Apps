#!/usr/bin/env bash
# ==============================================================================
# Home Assistant App: Obsidian
# Maps app options to the LinuxServer.io environment
# ==============================================================================
set -euo pipefail

OPTIONS_FILE="/data/options.json"
ENV_DIR="/run/s6/container_environment"

set_env() {
    printf '%s' "$2" > "${ENV_DIR}/$1"
}

USERNAME="$(jq -r '.username // empty' "${OPTIONS_FILE}")"
PASSWORD="$(jq -r '.password // empty' "${OPTIONS_FILE}")"

if [[ -n "${USERNAME}" && -n "${PASSWORD}" ]]; then
    set_env CUSTOM_USER "${USERNAME}"
    set_env PASSWORD "${PASSWORD}"
else
    echo "[obsidian-app] WARNING: no username/password set, the web UI is unprotected."
fi

# Keep existing configuration from older app versions when migrating to the
# Supervisor-managed app_config mount at /config.
mkdir -p /config /data/config
if [[ -d /data/config ]]; then
    cp -an /data/config/. /config/
fi

# Vault folder shared with the other apps (e.g. GitHub Sync: path "obsidian")
mkdir -p /share/obsidian
chown -R abc:abc /share/obsidian /config
chmod -R 777 /share/obsidian

# LinuxServer's nginx expects these files even when no custom certificate is set.
SSL_DIR="/config/ssl"
SSL_CERT="${SSL_DIR}/cert.pem"
SSL_KEY="${SSL_DIR}/key.pem"
mkdir -p "${SSL_DIR}"

if [[ -s /ssl/fullchain.pem && -s /ssl/privkey.pem ]]; then
    ln -sfn /ssl/fullchain.pem "${SSL_CERT}"
    ln -sfn /ssl/privkey.pem "${SSL_KEY}"
    echo "[obsidian-app] Using the Home Assistant SSL certificate."
elif [[ -s "${SSL_CERT}" && -s "${SSL_KEY}" ]]; then
    echo "[obsidian-app] Using the existing HTTPS certificate."
else
    if [[ -e /ssl/fullchain.pem || -e /ssl/privkey.pem ]]; then
        echo "[obsidian-app] WARNING: incomplete Home Assistant SSL pair; generating a self-signed certificate."
    fi
    umask 077
    openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
        -keyout "${SSL_KEY}" \
        -out "${SSL_CERT}" \
        -subj "/CN=localhost"
    chmod 600 "${SSL_KEY}"
    chmod 644 "${SSL_CERT}"
    chown abc:abc "${SSL_KEY}" "${SSL_CERT}"
    echo "[obsidian-app] Generated a self-signed HTTPS certificate."
fi
