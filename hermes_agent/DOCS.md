# Home Assistant App: Hermes Agent

## Installation

1. Install and start the app.
2. Open the Hermes Dashboard (port `9119`) and finish the provider/model
   setup there.

## Configuration

```yaml
start_mode: both
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

- The Hermes dashboard exposes API keys and session data and has no
  Home Assistant authentication. Keep port `9119` inside a trusted network or
  disable the host port in the app's **Network** section.
- The Home Assistant configuration folder is mounted **read-only** at
  `/homeassistant`; `/share` is writable.

## Data

Hermes state lives in `/data/hermes` and is included in backups.

## Notes

The start script relies on the image's own entrypoint and on the dashboard
options documented by Nous Research. If an upstream release changes them,
adjust `rootfs/run.sh` and pin `HERMES_VERSION` in the Dockerfile.
