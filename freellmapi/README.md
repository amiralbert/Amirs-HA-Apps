# Home Assistant App: FreeLLMAPI

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]

A local, OpenAI-compatible gateway that stacks the free tiers of many LLM
providers behind a single `/v1` endpoint, with smart routing and automatic
failover. Built from [tashfeenahmed/freellmapi][upstream].

## About

Point any OpenAI-compatible client (for example the Hermes Agent app in this
repository) at `http://<ha-host>:3001/v1`. Provider keys are managed in the
dashboard and stored encrypted.

See [DOCS.md](DOCS.md) for setup and configuration.

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[upstream]: https://github.com/tashfeenahmed/freellmapi
