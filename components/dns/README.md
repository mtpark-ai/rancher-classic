# components/dns

**Language:** Go
**Baseline:** `rancher/rancher-dns @ HEAD` (2017-09-26)
**Target (1.7.0):** Go 1.22+ · miekg/dns latest
**Phase:** 1 — scaffold only.

## Role
Internal DNS resolver for service discovery (stack-name.service-name pattern).
Sits in front of `rancher-metadata`.

## Modernization plan (Phase 4)
1. `go mod init`
2. Upgrade `github.com/miekg/dns` to latest
3. IPv6 support audit
