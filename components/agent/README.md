# components/agent

**Language:** Go
**Baseline:** `rancher/agent @ v0.13.11` (2019-01-03)
**Target (1.7.0):** Go 1.22+ · docker/docker/client v27 · Ubuntu 24.04 base
**Phase:** 1 — scaffold only.

## Role
Per-host agent container. Connects via WebSocket to Cattle server, receives
imperative instructions (create/start/stop containers, mount volumes, plug
network), and proxies them to the local Docker daemon.

The agent **image** in 1.6 (`rancher/agent:v1.2.11`) is built from the `agent/`
folder of the meta-repo `rancher/rancher@v1.6.30`, NOT directly from
`rancher/agent`. We will keep the meta-repo packaging here too, but use
`components/agent/` as the canonical source tree.

## Modernization plan (Phase 4 of master plan)
1. **Build**: drop Dapper + trash; new `go.mod`; multi-stage Dockerfile
2. **Docker SDK**: introduce `github.com/docker/docker/client` v27.x with API negotiation
3. **Mount-namespace helper `share-mnt`**: rewrite for systemd 254+
4. **Logging**: replace homegrown `loglevel` package with `zerolog` or `slog`

## Key files (in baseline)
- `main.go`                        — entry point
- `register/register.go`           — server registration handshake
- `trash.yml` → delete             — replaced by `go.mod`
- `Dockerfile.dapper` → delete     — replaced by `Dockerfile`
- `Makefile`                       — keep but rewrite to standard targets
