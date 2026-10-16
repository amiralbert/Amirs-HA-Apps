# Home Assistant App: Obsidian

## Installation

1. Install the app, set a username and password and start it. App configuration
   is stored in Home Assistant's persistent app configuration directory.
2. Open the web UI over HTTPS (port `3011`). If Home Assistant has both
   `/ssl/fullchain.pem` and `/ssl/privkey.pem` that match, the app uses them.
   Otherwise, it creates a self-signed certificate, so the browser will show a
   certificate warning until you trust it. HTTP on port `3010` is intended for
   use behind a reverse proxy; browser features used by Obsidian require a
   secure context.
3. In Obsidian choose **Open folder as vault** and select `/share/obsidian`.

## Configuration

```yaml
username: ""
password: ""
```

### Options: `username` and `password`

Basic-auth credentials for the web UI. If left empty the UI is unprotected, so
set both unless the port is strictly local.

## Combining with GitHub Sync

Configure a repository with `path: obsidian` in the GitHub Sync app to keep the
vault in a Git repository.

## Known limitations

- The upstream image is designed for `docker run` with `--shm-size` and, for
  the Electron sandbox, `--security-opt seccomp=unconfined`. Home Assistant
  does not let apps set these options, so Obsidian may crash or fail to start
  on some hosts. That is why the app is marked **experimental**.
- If Home Assistant SSL files are unavailable, the app uses a self-signed
  certificate and browsers will warn about it.
- Obsidian is a desktop app streamed to the browser: expect higher CPU and
  memory use than for a pure web service.
- Do not expose the ports to the internet.
