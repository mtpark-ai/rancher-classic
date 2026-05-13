# components/host-api

**Language:** Go
**Baseline:** `rancher/host-api @ HEAD` (last commit 2016-11-30)
**Target (1.7.0):** Go 1.22+ · docker/docker/client v27
**Phase:** 1 — scaffold only.

## Role
Agent-side HTTP/WebSocket service that proxies `exec`, `logs`, `stats`, and
file-browser requests from the Cattle UI through to the host's Docker daemon.

## Modernization plan (Phase 4)
1. Drop Dapper / trash / Godeps → `go mod init`
2. Replace `github.com/docker/docker/pkg/*` (v1.5.0-era) with `github.com/docker/docker/client` v27
3. Rewrite `stats` stream against new Docker stats API
4. Rewrite WebSocket exec hijack using new client TTY/Resize API

## Key files (in baseline)
- `main.go`                           — entry point
- `app/socket_proxy_handler.go`       — primary exec/logs WS handler
- `app/stats_handler.go`              — stats stream (full rewrite expected)
- `Godeps/Godeps.json` → delete
