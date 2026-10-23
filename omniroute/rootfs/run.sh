#!/usr/bin/env bash
# ==============================================================================
# Home Assistant App: OmniRoute
# Reads the app options and starts OmniRoute via the image's own entrypoint
# ==============================================================================
set -euo pipefail

OPTIONS_FILE="/data/options.json"

log() {
    echo "[omniroute-app] $*"
}

# Prints an option; arrays are printed one entry per line
opt() {
    node -e '
        const value = require(process.argv[1])[process.argv[2]];
        if (Array.isArray(value)) value.forEach((v) => console.log(v));
        else if (value !== undefined && value !== null) console.log(value);
    ' "${OPTIONS_FILE}" "$1"
}

INITIAL_PASSWORD_OPT="$(opt initial_password)"
REQUIRE_API_KEY_OPT="$(opt require_api_key)"
MEMORY_MB="$(opt memory_mb)"

# --- Persistent state --------------------------------------------------------
# SQLite database, logs, backups and the auto-generated secrets (server.env)
# live in /data/omniroute, which is part of Home Assistant backups. The app
# runs as root inside the container so /data is writable.
export DATA_DIR="/data/omniroute"
export HOME="/data/home"
mkdir -p "${DATA_DIR}" "${HOME}"

# --- Server ------------------------------------------------------------------
export PORT=20128
export HOSTNAME="0.0.0.0"
export OMNIROUTE_MEMORY_MB="${MEMORY_MB:-1024}"
export NODE_OPTIONS="--max-old-space-size=${OMNIROUTE_MEMORY_MB}"

# --- Authentication ----------------------------------------------------------
# Only used until a dashboard password is saved. Empty: set it in the
# onboarding wizard on first visit.
if [[ -n "${INITIAL_PASSWORD_OPT}" ]]; then
    export INITIAL_PASSWORD="${INITIAL_PASSWORD_OPT}"
else
    unset INITIAL_PASSWORD
fi

if [[ "${REQUIRE_API_KEY_OPT}" != "false" ]]; then
    export REQUIRE_API_KEY=true
else
    log "WARNING: require_api_key is off, the /v1 API accepts requests without a key."
    export REQUIRE_API_KEY=false
fi

# --- Extra environment variables ---------------------------------------------
while IFS= read -r entry; do
    [[ -z "${entry}" ]] && continue
    if [[ "${entry}" =~ ^([A-Za-z_][A-Za-z0-9_]*)=(.*)$ ]]; then
        export "${BASH_REMATCH[1]}=${BASH_REMATCH[2]}"
        log "Set environment variable ${BASH_REMATCH[1]}"
    else
        log "Skipping invalid environment entry (expected KEY=value)"
    fi
done < <(opt env_vars)

log "Starting OmniRoute on port ${PORT} (heap: ${OMNIROUTE_MEMORY_MB} MB)..."

cd /app || { log "ERROR: Application directory /app not found"; exit 1; }
exec /app/check-permissions.sh node dev/run-standalone.mjs
