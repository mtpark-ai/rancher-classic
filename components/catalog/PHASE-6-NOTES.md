# catalog — Phase 6 status

## Phase 2 — completed

Out-of-scope infra-templates **deleted**:

- IPsec overlay → `infra-templates/ipsec`
- Kubernetes provisioner → `infra-templates/k8s`
- Cloud-storage drivers → `aws-{ebs,efs,ecr,route53}`, `netapp-*`,
  `portworx`, `nfs`
- Windows agents → `windows`, `windows-network-services`,
  `ecr-windows`
- Secrets bridge v2 → `secrets-bridge-v2`

Out-of-scope project-templates **deleted**:

- `project-templates/{kubernetes,mesos,swarm,windows}` → only `cattle`
  remains as a deployable environment type

User-facing `templates/k8s`, `templates/kubernetes`, `templates/route53`
**deleted**; `templates/convoy-nfs` kept as opt-in storage driver.

## Phase 6 — to do

1. Add a new top version under each kept infra-template (e.g.
   `infra-templates/vxlan/14/`, `infra-templates/healthcheck/8/`) whose
   `docker-compose.yml.tpl` points at
   `ghcr.io/mtpark-ai/rancher-classic/<component>:1.7.0` instead of
   `rancher/net:v0.x` / `rancher/healthcheck:v0.x`.

2. Bump each kept template's `minimum_rancher_version` to `v1.7.0`.

3. Verify each kept template's docker-compose / rancher-compose still
   parses under Cattle's 1.7.0 schema. (No Cattle-side schema changes
   are planned in 1.7.0, so this is expected to be a no-op.)

4. Decide whether to point the default catalog URL at
   `https://github.com/mtpark-ai/rancher-classic/tree/main/components/catalog`
   (raw) or to publish the catalog as a separate repo.

## Kept infra-templates (11)

```
container-crontab        network-services
healthcheck              per-host-subnet
l2-flat                  pre-pull-images
network-diagnostics      scheduler
network-policy-manager   secrets
                         vxlan
```
