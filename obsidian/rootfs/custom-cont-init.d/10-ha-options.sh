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
chown -R abc:abc /share/obsidian
chmod -R 777 /share/obsidian

# LinuxServer's nginx expects these files even when no custom certificate is set.
SSL_DIR="/config/ssl"
SSL_CERT="${SSL_DIR}/cert.pem"
SSL_KEY="${SSL_DIR}/cert.key"
mkdir -p "${SSL_DIR}"

CERT_SOURCE="${SSL_CERT}"
KEY_SOURCE="${SSL_KEY}"
if [[ -s /ssl/fullchain.pem && -s /ssl/privkey.pem ]]; then
    CERT_SOURCE="/ssl/fullchain.pem"
    KEY_SOURCE="/ssl/privkey.pem"
elif [[ ! -s "${KEY_SOURCE}" && -s "${SSL_DIR}/key.pem" ]]; then
    KEY_SOURCE="${SSL_DIR}/key.pem"
fi

PAIR_MATCHES=false
if [[ -s "${CERT_SOURCE}" && -s "${KEY_SOURCE}" ]]; then
    if CERT_PUBLIC_KEY="$(openssl x509 -in "${CERT_SOURCE}" -pubkey -noout 2>/dev/null | openssl pkey -pubin -outform DER 2>/dev/null | sha256sum)" \
        && KEY_PUBLIC_KEY="$(openssl pkey -in "${KEY_SOURCE}" -pubout -outform DER 2>/dev/null | sha256sum)" \
        && [[ "${CERT_PUBLIC_KEY}" == "${KEY_PUBLIC_KEY}" ]]; then
        PAIR_MATCHES=true
    fi
fi

if [[ "${PAIR_MATCHES}" == true ]]; then
    if [[ "${CERT_SOURCE}" == /ssl/* ]]; then
        ln -sfn "${CERT_SOURCE}" "${SSL_CERT}"
        ln -sfn "${KEY_SOURCE}" "${SSL_KEY}"
        echo "[obsidian-app] Using the Home Assistant SSL certificate."
    elif [[ "${KEY_SOURCE}" == "${SSL_DIR}/key.pem" ]]; then
        ln -sfn "${KEY_SOURCE}" "${SSL_KEY}"
        echo "[obsidian-app] Using the existing HTTPS certificate."
    fi
else
    if [[ -e "${CERT_SOURCE}" || -e "${KEY_SOURCE}" ]]; then
        echo "[obsidian-app] WARNING: missing or mismatched HTTPS certificate and key; generating a new self-signed certificate."
    fi
    umask 077
    openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
        -keyout "${SSL_KEY}.new" \
        -out "${SSL_CERT}.new" \
        -subj "/CN=localhost"
    mv -f "${SSL_CERT}.new" "${SSL_CERT}"
    mv -f "${SSL_KEY}.new" "${SSL_KEY}"
    chmod 600 "${SSL_KEY}"
    chmod 644 "${SSL_CERT}"
    chown abc:abc "${SSL_KEY}" "${SSL_CERT}"
    echo "[obsidian-app] Generated a self-signed HTTPS certificate."
fi
