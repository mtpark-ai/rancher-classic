# host-api — Phase 4 blocked

This component is **not** delivered by Phase 2. It compiles **partially**
but several call sites require the Phase 4 Docker SDK migration before
`go build ./...` will pass.

Concrete blockers found while doing the Phase 2 sweep:

1. **JWT claims indexing** (`auth/auth.go`, `stats/*.go`):
   `token.Claims["key"]` no longer works on `dgrijalva/jwt-go` ≥ 3.x.
   Needs `token.Claims.(jwt.MapClaims)["key"]` everywhere.

2. **Docker SDK v27 API removals** (`stats/container_stats.go`, `stats/stats.go`):
   - `dclient.UpdateClientVersion(...)` — removed; use
     `client.NewClientWithOpts(client.WithVersion(...))`
   - `statsReader.Close()` — `container.StatsResponseReader` no longer
     implements `io.Closer` directly; wrap the underlying body
   - `types.ContainerListOptions` moved to
     `github.com/docker/docker/api/types/container.ListOptions`

3. **Event time field type** (`events/send_to_rancher_handler.go`):
   upstream `Event.Time` is now `int64` but old code assigns into an
   `int` field of a different struct.

The reusable Go CI workflow has been adjusted to mark `ci-host-api`
as `continue-on-error: true` for Phase 2. Re-enable as a hard gate
when Phase 4 lands.
