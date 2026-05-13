# agent — Phase 4 blocked

The agent is the central component of rancher-classic — every host runs
one and the entire control plane talks to it. It is also the most
Docker-SDK-heavy component (40+ imports across docker/docker, including
container, network, mount, blkiodev, filters, events).

Phase 2 has:
- removed Dapper / trash / vendor
- written a target `go.mod` with the Phase 4 dependency pins
- added monorepo `replace` directives for vendored third_party forks

Phase 2 has **not**:
- run `go mod tidy` end-to-end (most subpackages still call removed v17-era
  Docker SDK APIs)
- compiled any sub-package
- run vet / tests / build

## Concrete Phase 4 deliverables

1. **Docker SDK call-site sweep** across `handlers/`, `core/compute/`,
   `core/storage/`, `core/image/`, `events/`. Old patterns include:
   - `client.NewClient(host, version, nil, headers)` →
     `client.NewClientWithOpts(client.WithHost, client.WithVersion, ...)`
   - `client.ImagePull(ctx, ref, types.ImagePullOptions{...})` —
     `ImagePullOptions` moved to `image.PullOptions`
   - `client.ContainerList(ctx, types.ContainerListOptions{...})` —
     moved to `container.ListOptions`
   - Same pattern for `StatsResponseReader`, `ImageBuildOptions`, etc.

2. **`share-mnt` mount-namespace helper** must be rewritten for
   systemd 254+ (`mountinfo` parsing format changed, `nsenter` invocation
   differs under cgroup v2).

3. **`loglevel` package** — replace with stdlib `log/slog` or zerolog.

4. **Aliyun cloud provider** (`cloudprovider/aliyun/`) — pinned to a
   2017 fork (`loganhz/aliyungo`). Decide whether to support Aliyun
   metadata at all; if not, delete the cloudprovider/aliyun/ tree
   entirely (mirror of AWS-only support).

5. **Agent registration handshake** — verify against modernized Cattle
   server (Phase 3) before declaring the agent functional.

## CI

`ci-agent` workflow has been marked **advisory** for Phase 2. The
underlying job will still attempt `go mod tidy + build`; expect it to
fail until Phase 4 lands.
