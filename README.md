# Amirs Home Assistant Apps

Custom Home Assistant apps (formerly known as add-ons), structured after the
[Home Assistant apps example](https://github.com/home-assistant/apps-example).

[![Open this repository in the Home Assistant app store.](https://my.home-assistant.io/badges/supervisor_store.svg)](https://my.home-assistant.io/redirect/supervisor_store/?repository_url=https%3A%2F%2Fgithub.com%2Famiralbert%2FAmirs-HA-Apps)

## Apps

| App | Description |
| --- | --- |
| [FreeLLMAPI](./freellmapi) | Local OpenAI-compatible gateway for multiple LLM providers. |
| [Hermes Agent](./hermes_agent) | AI agent with dashboard, gateway, Git and persistent workspaces. |
| [Obsidian](./obsidian) | Obsidian in your browser with a vault in `/share/obsidian` (experimental). |
| [GitHub Sync](./github) | Synchronizes GitHub repositories in `/share`. |

## How the apps fit together

```
GitHub Sync ──► /share/obsidian  ◄── Obsidian (edit your vault)
            ──► /share/hermes/*  ◄── Hermes Agent (workspaces)
                                       │ OpenAI-compatible API
                                       ▼
                                   FreeLLMAPI
```

All apps exchange files via `/share`. Hermes Agent can connect to FreeLLMAPI
over HTTP; see the individual app documentation for details.

## Installation

1. Add this repository using the button above, or add
   `https://github.com/amiralbert/Amirs-HA-Apps` from the App Store's
   **Repositories** menu.
2. Open **Settings** > **Apps** > **App Store** (older versions: **Add-ons**).
3. Install the apps you want.

## Development

- Every app lives in a directory whose name matches its `slug`.
- Pull requests are linted and build all app images without publishing.
- Pushes to `main` build multi-architecture (`aarch64` and `amd64`) images and
  publish them to GitHub Container Registry using `.github/workflows/builder.yaml`.
- Keep the `version` in `config.yaml` and the app's `CHANGELOG.md` in sync.
- Published GHCR packages must be public for Home Assistant to pull the images.

## Support

[![Buy Me A Coffee](https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png)](https://buymeacoffee.com/Aalbert)

## License

MIT, see [LICENSE](LICENSE). Each packaged project keeps its own license.
