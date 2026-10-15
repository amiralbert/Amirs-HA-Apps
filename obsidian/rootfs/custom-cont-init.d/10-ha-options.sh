#!/usr/bin/env bash
# ==============================================================================
# Home Assistant App: Obsidian
# Maps app options to the LinuxServer.io environment and persists /config
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

# Persist the Obsidian configuration in /data (included in backups)
mkdir -p /data/config
if [[ ! -L /config ]]; then
    if [[ -d /config ]]; then
        cp -a /config/. /data/config/
    fi
    rm -rf /config
    ln -s /data/config /config
fi

# Vault folder shared with the other apps (e.g. GitHub Sync: path "obsidian")
mkdir -p /share/obsidian
chown -R abc:abc /share/obsidian /data/config
