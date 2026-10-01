# Sonarr — Easypanel / ARM64

> **Unofficial, deployment-focused fork.**
>
> This repository is a derivative of [Sonarr](https://github.com/Sonarr/Sonarr), maintained by [Jaison Perazza](https://github.com/jaison). It adds deployment and packaging adaptations intended for running Sonarr v5 with Docker on Easypanel and ARM64 (aarch64) systems.
>
> This is not an official Sonarr project or distribution, and it is not affiliated with or endorsed by the Sonarr maintainers.

## Purpose

The goal of this fork is to make deployment in the target environment easier, while keeping the upstream Sonarr application as the foundation.

Current adaptation scope:

- Multi-stage Docker build.
- ARM64 (linux-arm64 / aarch64) build target.
- Easypanel-oriented container configuration.
- Persistent volumes for configuration, TV library and downloads.

**Status:** The ARM64 image has been built and its runtime has been validated in an Easypanel deployment. This confirms the tested build and deployment path, but does not constitute broad production-readiness certification across other environments.

## Easypanel deployment

The container is intended to run as a single Sonarr instance with persistent storage.

### Service configuration

- **Internal HTTP port:** `8989`. Configure the Easypanel domain/proxy to forward traffic to this port; TLS termination is handled by the platform.
- **Replicas:** `1`. Do not run multiple Sonarr instances against the same configuration database.
- **Persistent volumes:**
  - `/config` — application configuration and SQLite databases.
  - `/tv` — TV library.
  - `/downloads` — download directory.
- **Update strategy:** use `stop-first` with update parallelism `1`, so the old task stops before a replacement starts.

For an Easypanel deployment backed by Docker Swarm, the service update settings can be applied with:

```bash
docker service update \
  --replicas 1 \
  --update-order stop-first \
  --update-parallelism 1 \
  <service_name>
```

Replace `<service_name>` with the actual Swarm service name. These are deployment settings managed by Easypanel/Docker Swarm; they are not configured by the Dockerfile.

### Startup and domain routing

After changing deployment or domain settings, if Easypanel reports that the service is not started while the container is already running, restart the service from the Easypanel panel to refresh its service state and routing configuration.

## Upstream lineage

This repository follows the original project through this fork chain:

- **Original project:** [Sonarr/Sonarr](https://github.com/Sonarr/Sonarr)
- **Intermediate fork:** [stevietv/Sonarr](https://github.com/stevietv/Sonarr)
- **This deployment fork:** [jaison/Sonarr](https://github.com/jaison/Sonarr)

The original Sonarr repository remains the authoritative source for the application's development, documentation and support. Issues specific to this fork's Docker build or Easypanel deployment should be reported here; application issues should be checked against the upstream project.

## Maintenance and changes

Changes in this repository are intended to stay focused on deployment, packaging and platform compatibility. They do not represent a separate Sonarr implementation or an alternative development roadmap.

Upstream changes may be incorporated as appropriate. Deployment-specific changes are maintained in this repository.

## License and credits

Sonarr is distributed under the GNU General Public License v3.0 (GPL-3.0). This fork retains the upstream license and notices. All original application code, project identity and contributor credits belong to their respective authors and contributors.

---

**Fork notice:** This repository contains modifications to the upstream project for a specific deployment environment. Adaptations in this fork are maintained independently and are not official Sonarr releases.

---

# <img width="24px" src="./Logo/256.png" alt="Sonarr"></img> Sonarr

[![Translated](https://translate.servarr.com/widget/servarr/sonarr/svg-badge.svg)](https://translate.servarr.com/engage/servarr/)
[![Backers on Open Collective](https://opencollective.com/Sonarr/backers/badge.svg)](#backers)
[![Sponsors on Open Collective](https://opencollective.com/Sonarr/sponsors/badge.svg)](#sponsors)
[![Mega Sponsors on Open Collective](https://opencollective.com/Sonarr/megasponsors/badge.svg)](#mega-sponsors)

Sonarr is a PVR for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new episodes of your favorite shows and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available.

## Getting Started

- [Download/Installation](https://sonarr.tv/#downloads-v3)
- [FAQ](https://wiki.servarr.com/sonarr/faq)
- [Wiki](https://wiki.servarr.com/Sonarr)
- [API Documentation](https://sonarr.tv/docs/api)
- [Donate](https://sonarr.tv/donate)

## Support

Note: GitHub Issues are for Bugs and Feature Requests Only

- [Forums](https://forums.sonarr.tv/)
- [Discord](https://discord.gg/M6BvZn5)
- [GitHub - Bugs and Feature Requests Only](https://github.com/Sonarr/Sonarr/issues)
- [IRC](https://web.libera.chat/?channels=#sonarr)
- [Reddit](https://www.reddit.com/r/sonarr)
- [Wiki](https://wiki.servarr.com/sonarr)

## Features

### Current Features

- Support for major platforms: Windows, Linux, macOS, Raspberry Pi, etc.
- Automatically detects new episodes
- Can scan your existing library and download any missing episodes
- Can watch for better quality of the episodes you already have and do an automatic upgrade. _eg. from DVD to Blu-Ray_
- Automatic failed download handling will try another release if one fails
- Manual search so you can pick any release or to see why a release was not downloaded automatically
- Fully configurable episode renaming
- Full integration with SABnzbd and NZBGet
- Full integration with Kodi, Plex (notification, library update, metadata)
- Full support for specials and multi-episode releases
- And a beautiful UI

## Contributing

### Development

This project exists thanks to all the people who contribute. [Contribute](CONTRIBUTING.md).

<a href="https://github.com/Sonarr/Sonarr/graphs/contributors"><img src="https://opencollective.com/Sonarr/contributors.svg?width=890&button=false" /></a>

### Supporters

This project would not be possible without the support of our users and software providers.
[**Become a sponsor or backer**](https://opencollective.com/sonarr) to help us out!

#### Mega Sponsors

[![Sponsors](https://opencollective.com/sonarr/tiers/mega-sponsor.svg?width=890)](https://opencollective.com/sonarr/contribute/mega-sponsor-21443/checkout)

#### Sponsors

[![Flexible Sponsors](https://opencollective.com/sonarr/sponsors.svg?width=890)](https://opencollective.com/sonarr/contribute/sponsor-21457/checkout)

#### Backers

[![Backers](https://opencollective.com/sonarr/backers.svg?width=890)](https://opencollective.com/sonarr/contribute/backer-21442/checkout)

#### JetBrains

Thank you to [<img src="https://resources.jetbrains.com/storage/products/company/brand/logos/jetbrains.png" alt="JetBrains" width="96">](http://www.jetbrains.com/) for providing us with free licenses to their great tools

[<img src="https://resources.jetbrains.com/storage/products/company/brand/logos/TeamCity.png" alt="TeamCity" width="64">](http://www.jetbrains.com/teamcity/)

[<img src="https://resources.jetbrains.com/storage/products/company/brand/logos/ReSharper.png" alt="ReSharper" width="64">](http://www.jetbrains.com/resharper/)

[<img src="https://resources.jetbrains.com/storage/products/company/brand/logos/dotTrace.png" alt="dotTrace" width="64">](http://www.jetbrains.com/dottrace/)

[<img src="https://resources.jetbrains.com/storage/products/company/brand/logos/Rider.png" alt="Rider" width="64">](http://www.jetbrains.com/rider/)

### Licenses

- [GNU GPL v3](http://www.gnu.org/licenses/gpl.html)
- Copyright 2010-2025
