# Home Assistant App: OmniRoute

## Installation

1. Install and start the app. The first start takes a moment while OmniRoute
   generates its secrets and database.
2. Open the web UI (port `20128`). If you did not set `initial_password`, the
   onboarding wizard asks you to create the dashboard password.
3. Connect your providers in the dashboard and create an API key.
4. Use the base URL `http://<ha-host>:20128/v1` and that API key in your
   clients.

## Configuration

```yaml
initial_password: ""
require_api_key: true
memory_mb: 1024
env_vars: []
```

### Option: `initial_password`

Dashboard password used only while no password is saved yet. After the first
login, change it under **Settings** > **Security** in the dashboard. Leave it
empty to create the password in the onboarding wizard instead.

### Option: `require_api_key`

When enabled (default), requests to `/v1` need an API key created in the
dashboard. Only disable it if nothing outside your trusted network can reach
port `20128`.

### Option: `memory_mb`

Node.js heap limit in MB. `1024` is enough for the dashboard and light chat.
Coding agents (for example Claude Code or Codex via `/v1/responses`) need much
more, upstream recommends `8192` for one agent. Make sure your Home Assistant
host has enough RAM.

### Option: `env_vars`

Additional OmniRoute settings as `KEY=value` entries, for example
`REDIS_URL=redis://...` or `STREAM_IDLE_TIMEOUT_MS=600000`. See the upstream
[`.env.example`][env] for all variables. `DATA_DIR` and `PORT` are managed by
the app.

## Using it from other apps

From other Home Assistant apps, use the hostname shown on this app's **Info**
page (for example `xxxxxxxx-omniroute`) with port `20128`:
`http://xxxxxxxx-omniroute:20128/v1`.

## Security

The dashboard does not use Home Assistant authentication. It is protected by
the OmniRoute dashboard password, the API by OmniRoute API keys. Do not expose
port `20128` to the internet; use a TLS reverse proxy for remote access.

## Data

The SQLite database, logs, backups and the auto-generated secrets
(`server.env`) are stored in `/data/omniroute` and are part of Home Assistant
backups. Keep `server.env` together with the database: without it, stored
provider credentials cannot be decrypted.

## Notes

This app uses the official `diegosouzapw/omniroute` image, pinned via
`OMNIROUTE_VERSION` in the Dockerfile. Providers that need a browser
(gemini-web, claude-web) are not supported, because they require the larger
`-web` image.

[env]: https://github.com/cheaper-inference/OmniRoute/blob/main/.env.example
