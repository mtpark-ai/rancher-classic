# rancher-classic

> **Status: 1.7.0-dev — Phase 1 scaffolding**

A community fork of [Rancher 1.x](https://github.com/rancher/rancher) (Cattle
architecture) modernized to run on **Ubuntu 24.04 LTS + Docker 27.x**, without
migrating to Rancher 2 / k3s.

This is **not** affiliated with Rancher Labs or SUSE. The upstream project
reached EOL on 2020-06-30 and the `rancher/cattle` repository was archived on
2022-01-04. This fork exists to extend the useful life of the Cattle
orchestration model for users whose workflows do not benefit from migrating
to Kubernetes.

## Scope

| In scope | Out of scope |
|---|---|
| Cattle orchestration engine (Java) | Kubernetes / Mesos / Swarm backends |
| VXLAN overlay networking | IPsec overlay |
| HAProxy load balancer | Cloud storage plugins (AWS / NetApp / Portworx) |
| Health-check, scheduler, metadata, DNS | Windows agent |
| Ember.js Web UI (preserved as-is) | Bundled MySQL (external DB required) |
| External MySQL/MariaDB | In-place upgrade from 1.6.x |

See [docs/ARCHITECTURE-DIFF.md](docs/ARCHITECTURE-DIFF.md) for the full
delta against upstream 1.6.30.

## Repository layout

```
.
├── baseline/         # Read-only upstream clones (not tracked)
├── components/       # 11 forked sub-components
│   ├── cattle/       # Java/Maven — orchestration engine
│   ├── agent/        # Go — host agent
│   ├── host-api/     # Go — agent-side HTTP API
│   ├── net/          # Go — VXLAN overlay
│   ├── healthcheck/  # Go — health monitoring
│   ├── scheduler/    # Go — container placement
│   ├── metadata/     # Go — service-discovery metadata
│   ├── dns/          # Go — internal DNS
│   ├── lb/           # HAProxy container
│   ├── catalog/      # Infrastructure-stack templates
│   └── ui/           # Ember.js Web UI
├── templates/        # Reusable Makefile / Dockerfile / CI templates
├── scripts/          # Top-level build / release orchestration
├── docs/             # ARCHITECTURE-DIFF, QUICKSTART, SECURITY-BACKLOG
└── .github/workflows/# Shared reusable workflows
```

## Build (once Phase 2 lands)

```sh
make build                # build all 11 images
make build COMPONENT=cattle   # build a single component
```

## Roadmap

The 8-phase implementation plan is at
[`~/.claude/plans/serene-crafting-hedgehog.md`](../.claude/plans/serene-crafting-hedgehog.md).

Estimated effort to GA: ~15 person-weeks.

## License

Apache License 2.0. See [LICENSE](LICENSE) and [NOTICE](NOTICE).
