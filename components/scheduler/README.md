# components/scheduler

**Language:** Go
**Baseline:** `rancher/scheduler @ HEAD` (2019-01-21)
**Target (1.7.0):** Go 1.22+
**Phase:** 1 — scaffold only.

## Role
Placement engine that decides which host a container goes on, based on
affinity rules, port pools, and resource constraints. Receives requests over
the Cattle event bus.

## Modernization plan (Phase 4)
1. `go mod init`; replace trash vendoring
2. Upgrade `go-rancher` client
3. No direct Docker SDK dependency — relatively easy migration

## Key files
- `main.go`
- `scheduler/*.go`
- `events/events.go`
