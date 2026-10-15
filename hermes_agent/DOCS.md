# Home Assistant App: Hermes Agent

## Installation

1. Install and start the app.
2. Open the Hermes Dashboard (port `9119`) and finish the provider/model
   setup there.

## Configuration

```yaml
start_mode: both
dashboard_username: hermes
dashboard_password: ""
llm_base_url: ""
llm_api_key: ""
openrouter_api_key: ""
git_username: ""
git_email: ""
git_token: ""
workspaces: []
```

### Option: `start_mode`

- `dashboard`: only the web dashboard.
- `gateway`: only the messaging gateway.
- `both`: gateway plus dashboard.

### Options: `dashboard_username` and `dashboard_password`

Set a dashboard username and password before starting in `dashboard` or `both`
mode. The bundled Hermes password provider protects the dashboard; unauthenticated
public dashboard access is not supported. `gateway` mode does not require these
options.

### Options: `llm_base_url` and `llm_api_key`

Optional OpenAI-compatible endpoint, exported as `OPENAI_BASE_URL` and
`OPENAI_API_KEY`. To use the FreeLLMAPI app, set the base URL to
`http://<freellmapi-hostname>:3001/v1` (hostname: see the FreeLLMAPI app's
**Info** page) and the API key to the unified key from the FreeLLMAPI
dashboard. You may need to select this endpoint as provider in the Hermes
dashboard as well.

### Option: `openrouter_api_key`

Optional OpenRouter key, exported as `OPENROUTER_API_KEY`.

### Options: `git_username`, `git_email`, `git_token`

Global Git identity. With username and token set, HTTPS access to `github.com`
is authenticated via a credential store in `/data`. Use a fine-grained token
with only the permissions the agent needs.

### Option: `workspaces`

Folder names created under `/share/hermes` (also reachable as
`/opt/workspaces`). Allowed characters: letters, digits, `.`, `_`, `-`.

## Security notes

- The Hermes dashboard exposes API keys and session data and does not use
  Home Assistant authentication. It is protected by the configured Hermes
  dashboard credentials. Keep port `9119` inside a trusted network, use a TLS
  reverse proxy for remote access, or disable the host port in the app's
  **Network** section.
- The Home Assistant configuration folder is mounted **read-only** at
  `/homeassistant`; `/share` is writable.

## Data

Hermes state lives in `/data/hermes` and is included in backups.

## Notes

The start script passes the selected Hermes command to the image's
`entrypoint-dispatch.sh` so s6-overlay can run its bootstrap and supervision
services. If an upstream release changes this entrypoint or the dashboard
options, adjust `rootfs/run.sh` and pin `HERMES_VERSION` in the Dockerfile.
