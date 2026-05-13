# components/ui

**Language:** JavaScript (Ember.js 2.x)
**Baseline:** `rancher/ui @ HEAD` (still actively committed in 2026 by upstream for Rancher 2 UI work; we need the 1.6.x branch — TBD)
**Target (1.7.0):** original Ember 2.x preserved; only API path adjustments + npm-audit-clean
**Phase:** 1 — scaffold only.

> **Action item before Phase 7:** confirm which upstream branch/tag corresponds
> to the 1.6.30 UI. Likely `master` branch frozen at a 2020-era SHA, OR a
> dedicated `v1.6` branch. The current default-branch HEAD is Rancher 2-UI
> work and is **not** what we want.

## Role
Ember.js Single Page App served by Cattle. Renders environments, stacks,
services, containers; provides terminal (xterm.js) and stats views.

## Modernization plan (Phase 7)
1. Pin to correct 1.6.x baseline ref
2. Get `ember build` running on Node 20:
   - `node-sass` → `sass-embedded`
   - `phantomjs` → `playwright` for tests
3. Delete `app/{k8s-*, mesos-*, swarm-*}/` route trees
4. Delete corresponding `/v3-public/{kubernetes, mesos, swarm}` API client calls
5. `npm audit fix` to zero high/critical
6. **No** redesign — preserve look-and-feel
