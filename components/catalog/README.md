# components/catalog

**Type:** YAML / docker-compose / rancher-compose templates
**Baseline:** `rancher/rancher-catalog @ HEAD` (master, archived 2024-03-25)
**Target (1.7.0):** template-per-system-stack, all pointing at `ghcr.io/mtpark-ai/rancher-classic/*` images
**Phase:** 1 — scaffold only.

## Role
The default catalog of "infra-templates" that Cattle deploys when a host is
added to an environment. Selecting the "Cattle" environment template pulls
from here.

## Modernization plan (Phase 6)
1. Delete K8s/Mesos/Swarm infra-templates:
   ```
   infra-templates/kubernetes*
   infra-templates/mesos*
   infra-templates/swarm*
   infra-templates/*-ipsec*
   ```
2. Delete cloud-storage templates:
   ```
   infra-templates/aws-* infra-templates/netapp-* infra-templates/portworx
   infra-templates/ecr infra-templates/efs infra-templates/ebs
   infra-templates/route53
   ```
3. Keep & repoint to fork:
   ```
   infra-templates/healthcheck
   infra-templates/scheduler
   infra-templates/network-services
   infra-templates/ipsec → rename to "vxlan"; rewrite docker-compose.yml
   infra-templates/metadata
   infra-templates/dns
   infra-templates/lb-service-haproxy
   ```
4. Top-level `config.yml`: bump `minimumRancherVersion` to `v1.7.0`
5. Catalog repo URL pointed at `https://github.com/mtpark-ai/rancher-classic` (path `components/catalog/`)
