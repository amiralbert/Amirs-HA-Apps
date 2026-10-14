# Home Assistant App: FreeLLMAPI

## Installation

1. Install the app and start it.
2. Open the log: on the first start FreeLLMAPI prints a one-time **setup code**.
   Because the app is reachable from other devices, you need this code to
   create the first dashboard account.
3. Open the web UI (port `3001`), create your account and add provider keys on
   the **Keys** page.
4. Copy the unified API key from the **Keys** page header and use it in your
   clients, together with the base URL `http://<ha-host>:3001/v1`.

Use the free tiers responsibly and respect each provider's terms. The upstream
project is meant for personal experimentation, not production use.

## Configuration

```yaml
encryption_key: ""
response_cache: false
compression: "off"
dashboard_origins: ""
```

### Option: `encryption_key`

Key used to encrypt the stored provider API keys (64 hex characters). Leave
empty to let the app generate one and store it in `/data/.encryption-key`.
Back this key up together with the app data: without it, stored provider keys
cannot be decrypted. Generate one with
`node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"`.

### Option: `response_cache`

Serve identical non-streaming chat requests from memory instead of spending
provider quota.

### Option: `compression`

Request-side prompt compression: `off`, `lossless`, `standard` or `aggressive`.

### Option: `dashboard_origins`

Comma-separated extra origins allowed to call the API from a browser, only
needed if you serve the dashboard from a different host.

## Using it from other apps

From other Home Assistant apps, use the hostname shown on this app's **Info**
page (for example `xxxxxxxx-freellmapi`) with port `3001`:
`http://xxxxxxxx-freellmapi:3001/v1`.

## Security

The dashboard and API are only protected by the dashboard account and the
unified API key. Do not expose port `3001` to the internet.

## Data

All data (SQLite database, encryption key) is stored in `/data` and is part of
Home Assistant backups.
