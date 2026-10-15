#!/usr/bin/env bash
# ==============================================================================
# Home Assistant App: Hermes Agent
# Reads the app options and starts Hermes Agent via the image's own entrypoint
# ==============================================================================
set -euo pipefail

OPTIONS_FILE="/data/options.json"

log() {
    echo "[hermes-app] $*"
}

opt() {
    jq -r --arg key "$1" '.[$key] // empty' "${OPTIONS_FILE}"
}

START_MODE="$(opt start_mode)"
START_MODE="${START_MODE:-both}"
LLM_BASE_URL="$(opt llm_base_url)"
LLM_API_KEY="$(opt llm_api_key)"
OPENROUTER_KEY="$(opt openrouter_api_key)"
GIT_USER="$(opt git_username)"
GIT_EMAIL="$(opt git_email)"
GIT_TOKEN="$(opt git_token)"

# --- Persistent state --------------------------------------------------------
export HERMES_HOME="/data/hermes"
mkdir -p "${HERMES_HOME}"
# Run as root inside the container so /data is writable
export HERMES_UID=0
export HERMES_GID=0

# --- Workspaces (shared via /share/hermes) -----------------------------------
WS_BASE="/share/hermes"
mkdir -p "${WS_BASE}"
while IFS= read -r ws; do
    [[ -z "${ws}" ]] && continue
    if [[ "${ws}" =~ ^[A-Za-z0-9._-]+$ ]]; then
        mkdir -p "${WS_BASE}/${ws}"
    else
        log "Skipping invalid workspace name: ${ws}"
    fi
done < <(jq -r '.workspaces[]?' "${OPTIONS_FILE}")
ln -sfn "${WS_BASE}" /opt/workspaces

# --- Git ---------------------------------------------------------------------
export GIT_CONFIG_GLOBAL="/data/gitconfig"
git config --global --add safe.directory '*'
if [[ -n "${GIT_USER}" ]]; then
    git config --global user.name "${GIT_USER}"
fi
if [[ -n "${GIT_EMAIL}" ]]; then
    git config --global user.email "${GIT_EMAIL}"
fi
if [[ -n "${GIT_USER}" && -n "${GIT_TOKEN}" ]]; then
    git config --global credential.helper "store --file=/data/git-credentials"
    echo "https://${GIT_USER}:${GIT_TOKEN}@github.com" > /data/git-credentials
    chmod 600 /data/git-credentials
fi

# --- LLM access --------------------------------------------------------------
if [[ -n "${LLM_BASE_URL}" ]]; then
    export OPENAI_BASE_URL="${LLM_BASE_URL}"
    export OPENAI_API_BASE="${LLM_BASE_URL}"
fi
if [[ -n "${LLM_API_KEY}" ]]; then
    export OPENAI_API_KEY="${LLM_API_KEY}"
fi
if [[ -n "${OPENROUTER_KEY}" ]]; then
    export OPENROUTER_API_KEY="${OPENROUTER_KEY}"
fi

# --- Start mode --------------------------------------------------------------
case "${START_MODE}" in
    dashboard)
        args=(dashboard --host 0.0.0.0 --insecure --no-open)
        ;;
    gateway)
        args=(gateway run)
        ;;
    *)
        # Gateway plus the built-in dashboard as a sub-process
        export HERMES_DASHBOARD=1
        export HERMES_DASHBOARD_HOST=0.0.0.0
        args=(gateway run)
        ;;
esac

log "Starting Hermes Agent (mode: ${START_MODE})..."

ENTRYPOINT_DISPATCH="/opt/hermes/docker/entrypoint-dispatch.sh"
if [[ -x "${ENTRYPOINT_DISPATCH}" ]]; then
    exec "${ENTRYPOINT_DISPATCH}" "${args[@]}"
fi

log "ERROR: Hermes image entrypoint dispatcher not found at ${ENTRYPOINT_DISPATCH}"
exit 1
