# components/healthcheck

**Language:** Go
**Baseline:** `rancher/healthcheck @ HEAD` (2018-07-08)
**Target (1.7.0):** Go 1.22+ · distroless base
**Phase:** 1 — scaffold only.

## Role
Standalone container that polls service health endpoints via HAProxy and feeds
state back to Cattle, which then schedules replacements.

## Modernization plan (Phase 4 — lowest risk)
1. `go mod init` (no Docker SDK dependency)
2. Upgrade `go-rancher` client to a fork that speaks the 1.7 Cattle API
3. Base image: `gcr.io/distroless/static-debian12`

## Key files
- `main.go`
- `healthcheck/healthcheck.go`
- `trash.conf` → delete
