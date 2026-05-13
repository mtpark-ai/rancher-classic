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
1. `go mod init`; replace trash vendoring — **done in Phase 2**
2. Upgrade `go-rancher` client — **deferred to Phase 4**
3. **Phase 4 must rewrite `events/listener.go`**: upstream
   `event-subscriber.NewEventRouter` changed from a 9-arg signature to a
   3-arg signature in 2018 (now takes `*v3.RancherClient` instead of
   `cattleURL + accessKey + secretKey`). The handler signature also moved
   from `*v2.RancherClient` to `*v3.RancherClient`. For Phase 2 the
   listener is stubbed to return an error.
4. `events/handler.go` deleted (Phase-4 rewrite expected).

## Key files
- `main.go`
- `scheduler/*.go`
- `events/listener.go` — Phase 4 placeholder
