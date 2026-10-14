# Amirs Home Assistant Apps

Custom Home Assistant apps (formerly known as add-ons), structured after the
[Home Assistant apps example](https://github.com/home-assistant/apps-example)
and the community conventions popularised by
[frenck's add-ons](https://github.com/hassio-addons).

[![Open your Home Assistant instance and show the add app repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Famiralbert%2FAmirs-HA-Apps)

## Apps

| App | Description |
| --- | --- |
| [FreeLLMAPI](./freellmapi) | Local OpenAI-compatible gateway that stacks the free tiers of many LLM providers. |
| [Hermes Agent](./hermes_agent) | Self-improving AI agent by Nous Research (gateway and/or dashboard) with Git and workspaces. |
| [Obsidian](./obsidian) | Obsidian desktop in your browser, with the vault stored in `/share/obsidian` (experimental). |
| [GitHub Sync](./github) | Keeps GitHub repositories in `/share` in sync (pull, optional auto-commit and push). |

## How the apps fit together

```
GitHub Sync ──► /share/obsidian  ◄── Obsidian (edit your vault)
            ──► /share/hermes/*  ◄── Hermes Agent (workspaces)
                                       │ OpenAI-compatible API
                                       ▼
                                   FreeLLMAPI
```

All apps exchange files via the `/share` folder. Hermes Agent talks to
FreeLLMAPI over HTTP (see the Hermes Agent documentation).

## Installation

1. Click the button above to add this repository to your Home Assistant.
2. Open **Settings** > **Apps** > **App Store** (older versions: **Add-ons**).
3. Install the apps you want.

## Development

- Every app lives in its own folder; the folder name equals the `slug`.
- Images are built by GitHub Actions on every push to `main`
  (`.github/workflows/builder.yaml`), for `aarch64` and `amd64`, and published
  to `ghcr.io/amiralbert/<image>`.
- Bump `version` in the app's `config.yaml` **and** add an entry to its
  `CHANGELOG.md` for every release.
- While developing locally, comment out the `image:` key in `config.yaml` so
  the Supervisor builds the image on your device.
- After the first successful build, set the packages on GitHub Container
  Registry to **public**, and allow workflows write access
  (Settings > Actions > General > Workflow permissions).

## Support

[![Buy Me A Coffee](https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png)](https://buymeacoffee.com/Aalbert)

## License

MIT, see [LICENSE](LICENSE). Each packaged project keeps its own license.
