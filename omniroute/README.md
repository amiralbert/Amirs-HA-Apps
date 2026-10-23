# Home Assistant App: OmniRoute

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]

[OmniRoute][upstream] packaged for Home Assistant: a unified AI router that
puts many LLM providers behind one OpenAI-compatible endpoint, with automatic
fallback, combos, usage tracking and a web dashboard.

Point any OpenAI-compatible client (for example the Hermes Agent app in this
repository) at `http://<ha-host>:20128/v1`.

See [DOCS.md](DOCS.md) for setup and configuration.

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[upstream]: https://github.com/cheaper-inference/OmniRoute
