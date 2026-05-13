# ui — Phase 7 status

## Phase 1/2 retrospective: this baseline took some work to identify

`rancher/ui` is still actively committed by SUSE in 2026, but those
commits are Rancher 2's UI. The correct 1.6.x baseline is the
**`v1.6.52` tag** (latest release on the `1.6-fixes`-style branches),
synchronized with `cattle.jar` which bundles `API UI v1.6.52`.

`baseline/ui` has been re-cloned at `v1.6.52`.

## What Phase 2 did

- Seeded `components/ui/` from `v1.6.52` (13 MB)
- Stripped K8s/Mesos/Swarm route trees and orchestration UIs:
  - `app/{k8s-tab, mesos-tab, swarm-tab}/` (whole trees)
  - `app/components/swarm/`
  - `app/services/{swarm.js, mesos.js, k8s.js}`
  - `app/components/orchestration/wait-{kubernetes, swarm, mesos}/`
  - `app/models/{kubernetesstack, kubernetesservice}.js`
  - `app/mixins/k8s-pod-selector.js`
- CI workflow is notice-only (Phase 7 blocked)

## What Phase 7 must do

### 1. Tool-chain modernization (largest chunk; 3-5 days)

The baseline ships with a Node-6, Ember-CLI-2.9.1, node-sass-4 stack
that does **not** install or build on Node 20. Specific known
breakages:

| Package | Status | Replacement |
|---|---|---|
| `node-sass` 4.x | uses deprecated libsass C++ binding | `sass` (dart-sass) |
| `ember-cli` 2.9.1 | requires Node 4-8 | `ember-cli` 3.28 LTS (last with Ember Classic API support) |
| `bower` | upstream dead | drop entirely; bring deps to npm |
| `phantomjs-prebuilt` | upstream dead | drop test runner or move to `playwright` |
| `broccoli-asset-rev` 2.x | abandoned | upgrade to current |
| `ember-browserify` | abandoned | replace with native ES modules |
| `fsevents` 1.x | macOS-only, build failures | bump to 2.x |

**Strategy:** containerize the build during the transition.

```
FROM node:8-alpine AS legacy-builder   # builds with the 2017 toolchain
WORKDIR /src
COPY package.json bower.json .
RUN npm install && bower --allow-root install
COPY . .
RUN ./node_modules/.bin/ember build --environment=production

FROM nginx:alpine
COPY --from=legacy-builder /src/dist /usr/share/nginx/html
```

This is technically a step backwards but unblocks shipping. A second
Phase 7 pass (1-2 weeks) can convert to a Node 20 build properly.

### 2. API-path scrubbing (1 day)

After K8s/Mesos/Swarm route dirs are gone, **25 files still reference
`kubernetes` / `mesos` / `swarmkit`** in their Handlebars templates or
JS controllers (mostly in environment templates, navigation menus,
and feature-flag checks). Scrub each:

```sh
grep -rl -i 'kubernetes\|mesos\|swarmkit' components/ui/app \
  --include='*.js' --include='*.hbs'
```

Each match should be either deleted (orchestrator selector lists,
"choose your platform" intro screens) or made unconditional on Cattle.

### 3. API client repointing (0.5 day)

UI calls Cattle API v1, v2-beta, and v3-public paths. Phase 3's
external-DB-only change means the `/v3-public/setup` flow goes away,
and `app/services/store.js` should be audited to remove any K8s/Mesos
backend lookups.

### 4. Branding (0.5 day)

The UI is still branded "Rancher". Per NOTICE, we should rebrand to
"rancher-classic" or a project-specific name. Key sites:

- `app/templates/login.hbs` — login splash
- `public/assets/images/logos/` — rancher.svg, etc.
- `translations/en.yml` — every "Rancher" → "rancher-classic"
- Browser title / favicon

### 5. CI re-enable (0.25 day)

Replace `ci-ui.yml`'s `notice` job with the real Ember build (matrix:
Node 20). Use the legacy container builder from step 1 if pure-Node-20
build is still broken.

## Estimated effort

≈ **1.0 person-week** total, dominated by step 1 (tool-chain).

If step 1 ends up impossible (Ember 2.x truly cannot be coaxed into a
modern Node), the contingency is a full UI rewrite to React/Vue —
that's a 4-6 person-week project (and explicitly out of 1.7.0 scope
per the original plan; see `~/.claude/plans/serene-crafting-hedgehog.md`
under "后续可选扩展").
