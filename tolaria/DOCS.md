# Home Assistant App: Tolaria

## Installation

1. Install the app, set a username and password and start it. App configuration
   is stored in Home Assistant's persistent app configuration directory.
2. Open the web UI over HTTPS (port `3021`). If Home Assistant has both
   `/ssl/fullchain.pem` and `/ssl/privkey.pem` that match, the app uses them.
   Otherwise, it creates a self-signed certificate, so the browser will show a
   certificate warning until you trust it. HTTP on port `3020` is intended for
   use behind a reverse proxy; the web desktop requires a secure context.
3. In Tolaria open or create a vault in `/share/tolaria`.

## Configuration

```yaml
username: admin
password: ""
```

### Options: `username` and `password`

Basic-auth credentials for the web UI. If either is empty the UI is
unprotected, so set both unless the port is strictly local.

## Combining with GitHub Sync

Tolaria has its own Git integration. Alternatively, configure a repository with
`path: tolaria` in the GitHub Sync app to keep the vault in a Git repository.
Do not let both push to the same repository at the same time.

## Known limitations

- Upstream only publishes Linux builds for `amd64`. On `aarch64` hosts such as
  a Raspberry Pi, the app runs Tolaria built from the same release's source
  code, without upstream crash reporting.
- Tolaria is a desktop app streamed to the browser: expect higher CPU and memory
  use than for a pure web service.
- The upstream base image is designed for `docker run` with `--shm-size`. Home
  Assistant does not let apps set this, so Tolaria may be slow or crash on some
  hosts. That is why the app is marked **experimental**.
- If Home Assistant SSL files are unavailable, the app uses a self-signed
  certificate and browsers will warn about it.
- Do not expose the ports to the internet.

## License

Tolaria is licensed under AGPL-3.0-or-later; the Tolaria name and logo are
trademarks of their owners. This app only packages the official release.
