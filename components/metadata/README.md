# components/metadata

**Language:** Go
**Baseline:** `rancher/rancher-metadata @ HEAD` (2018-07-08)
**Target (1.7.0):** Go 1.22+
**Phase:** 1 — scaffold only.

## Role
Service-discovery metadata server. Containers query
`http://rancher-metadata/latest/self/...` to discover sibling containers, IPs,
stack labels, etc.

## Modernization plan (Phase 4)
1. `go mod init`
2. Refresh `go-rancher` client
3. HTTP server: replace homegrown router with `net/http` `ServeMux`
   (Go 1.22 pattern routing) — small win, less dependency surface
