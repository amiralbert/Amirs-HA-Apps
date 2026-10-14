# Home Assistant App: Obsidian

## Installation

1. Install the app, set a username and password and start it.
2. Open the web UI. HTTPS (port `3011`, self-signed certificate) is
   recommended; plain HTTP is on port `3010`.
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
- Obsidian is a desktop app streamed to the browser: expect higher CPU and
  memory use than for a pure web service.
- Do not expose the ports to the internet.
