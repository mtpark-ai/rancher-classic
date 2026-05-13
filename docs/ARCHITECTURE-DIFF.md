# Architecture differences: rancher-classic 1.7.0 vs Rancher 1.6.30

This document tracks every intentional deviation from the upstream Rancher
1.6.30 reference, so operators familiar with 1.6 can quickly orient.

## 1. Orchestration engines

| Backend       | 1.6.30 | 1.7.0 |
|---------------|:------:|:-----:|
| Cattle        |   ✅   |  ✅   |
| Kubernetes    |   ✅   |  ❌   |
| Mesos         |   ✅   |  ❌   |
| Docker Swarm  |   ✅   |  ❌   |

K8s/Mesos/Swarm modules (`code/implementation/{kubernetes,mesos,swarm}/`)
and their launcher resources are removed from Cattle. Environment templates
that referenced these backends are deleted from the catalog.

## 2. Networking

| Capability             | 1.6.30        | 1.7.0           |
|------------------------|---------------|-----------------|
| Overlay: IPsec         | default       | **removed**     |
| Overlay: VXLAN         | optional      | **default**     |
| Firewall backend       | iptables-legacy | nftables (preferred) / iptables-legacy (compat) |
| cgroup compatibility   | v1 only       | v1 + v2         |

`strongSwan` and `goStrongswanVici` removed. `rancher-net` simplified to a
single VXLAN backend using `vishvananda/netlink`.

## 3. Operating systems & runtimes

| Surface         | 1.6.30 baseline      | 1.7.0 baseline       |
|-----------------|----------------------|----------------------|
| OS (tested)     | Ubuntu 16.04 / 18.04 | Ubuntu 24.04 LTS     |
| Docker (tested) | 1.12.3 – 19.03       | 25.x – 27.x          |
| Docker API min  | 1.24                 | 1.41                 |
| Kernel          | 3.10+                | 6.8+                 |

## 4. Server container

| Element                | 1.6.30                   | 1.7.0                          |
|------------------------|--------------------------|--------------------------------|
| Base image             | Ubuntu 16.04 + s6        | Ubuntu 24.04 + tini            |
| Embedded MySQL         | yes (single-node mode)   | **removed** — external DB only |
| Java runtime           | OpenJDK 8                | Temurin 17                     |
| Process supervisor     | s6-svscan                | tini + systemd-less init       |
| API UI bundled         | yes                      | yes (Ember 2.x, frozen)        |
| Rancher CLI / Compose  | bundled                  | bundled (separate `apt` opt-out) |

## 5. Agent container

| Element                | 1.6.30                   | 1.7.0                       |
|------------------------|--------------------------|-----------------------------|
| Base image             | Ubuntu 16.04             | Ubuntu 24.04                |
| Python runtime         | 2.7                      | 3.12                        |
| `share-mnt`            | embedded                 | rewritten for systemd 254+  |
| Docker SDK             | docker-java 1.1.0 (server side) + Go fragments | `github.com/docker/docker/client v27` |

## 6. Stripped sub-projects

| Project                      | Rationale |
|------------------------------|-----------|
| `rancher/win-agent`          | Windows host orchestration unused in target deployments |
| `infra-templates/aws-*`      | AWS-native storage; users migrate to in-cluster volumes |
| `infra-templates/netapp-*`   | Enterprise storage plugin; out of scope for community fork |
| `infra-templates/portworx`   | Same |
| `infra-templates/route53`    | Replaced by ExternalDNS conventions |
| `go-machine-service` Docker-machine provisioning | docker-machine archived upstream; IaC tools (Terraform/Pulumi) take over |

## 7. Behavior changes operators should know

- **Database**: `rancher/server` no longer brings its own MySQL. Operators
  must provide `CATTLE_DB_CATTLE_MYSQL_HOST` (and credentials). MariaDB
  10.11+ supported alongside MySQL 8.0+.
- **Image format**: Layers using **zstd compression** (Docker 23+ feature)
  are accepted. Legacy Docker Image v1 / schema1 manifests are rejected
  (matches Docker 28 behavior).
- **iptables backend detection**: `rancher-net` refuses to start if both
  iptables-legacy *and* nftables have active rule sets. Pick one.
- **Catalog URL**: the default infrastructure catalog points at
  `https://github.com/mtpark-ai/rancher-classic/tree/main/components/catalog`
  (raw), not `https://github.com/rancher/rancher-catalog`.
- **No in-place upgrade**: there is no migration path from a running
  Rancher 1.6.x environment. Operators must export stacks via the
  `rancher-classic-migrate` CLI (Phase 8 deliverable) and redeploy.

## 8. Versioning policy

- `1.7.x` patch releases: bug fixes, dependency CVE bumps, no behavior
  changes.
- `1.8.x` minor releases: additive features; old configs continue to work.
- `2.0.x`: reserved for any compatibility break (e.g., dropping cgroup v1).
