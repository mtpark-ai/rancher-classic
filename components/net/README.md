# components/net

**Language:** Go
**Baseline:** `rancher/rancher-net @ HEAD` (last commit 2017-11-07, tiny repo — most network code lives elsewhere)
**Target (1.7.0):** Go 1.22+ · VXLAN-only · nftables-aware
**Phase:** 1 — scaffold only.

> **Note:** The rancher-net baseline is unexpectedly thin (268K). The IPsec and
> VXLAN backends may live across other repos (`rancher/plugin-manager`,
> `rancher/cni-driver`, etc.). Phase 5 will start with a code-archaeology
> session to inventory the real network plane.

## Role
Overlay networking driver for the Cattle "managed" network. Originally
provided both **IPsec** (via strongSwan vici) and **VXLAN** (via kernel
netlink) backends.

## Modernization plan (Phase 5)
1. **Delete IPsec** entirely: `ipsec/`, `backend/ipsec/`, `vendor/github.com/bronze1man/goStrongswanVici`
2. **Keep VXLAN**: upgrade `vishvananda/netlink` to latest
3. **nftables adaptation**:
   - either: shell out to iptables/nft with explicit backend detection
   - or: use `github.com/google/nftables` natively (preferred)
4. **cgroup v2 path resolution**: rewrite any `/sys/fs/cgroup/<controller>/...`
   parsing to be cgroup-version-aware
5. **Default network template**: change from `ipsec` to `vxlan` everywhere
   (including `components/catalog`)

## Key files
- `cmd/rancher-net/main.go`
- `vxlan/*.go` — keep & modernize
- `ipsec/*.go` — delete
