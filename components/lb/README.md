# components/lb

**Language:** Go (controller) + HAProxy (data plane)
**Baseline:** `rancher/lb-controller @ HEAD` (2018-02-27); HAProxy 2.1.4 pinned in upstream 1.6.30's `rancher/lb-service-haproxy:v0.9.14`
**Target (1.7.0):** Go 1.22+ · HAProxy 2.8 LTS · Ubuntu 24.04 base
**Phase:** 1 — scaffold only.

## Role
HAProxy-based L7 / L4 load balancer service. The Go controller renders
`haproxy.cfg` from Cattle metadata and reloads HAProxy on changes.

## Modernization plan (Phase 4 / 6)
1. `go mod init`; drop trash
2. HAProxy 2.1.4 → 2.8 LTS (current stable LTS); validate config-file syntax
3. Base image: `ubuntu:24.04` with `haproxy` from official apt
4. Drain-friendly reload using `socat` to runtime API

## Key files
- `main.go`
- `provider/haproxy/*.go`         — config rendering
- `package/build.sh`              — Dockerfile build helper
- `Dockerfile.dapper` → delete
