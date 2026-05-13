# Phase 1 — Completion report

**Date:** 2026-05-13
**Plan reference:** `~/.claude/plans/serene-crafting-hedgehog.md`

## What landed

| Deliverable | Where | Status |
|---|---|---|
| Workspace skeleton | `~/rancher-classic-workspace/` | ✅ |
| LICENSE (Apache-2.0), NOTICE (fork attribution), CHANGELOG, .gitignore, README, VERSION | repo root | ✅ |
| 12 baseline upstream clones (shallow, depth=1) | `baseline/` (gitignored) | ✅ |
| 11 component directories with per-component READMEs | `components/<name>/` | ✅ |
| Shared CI templates (Go + Java reusable workflows + release) | `.github/workflows/_reusable-*.yml` | ✅ |
| Per-component CI workflows (11 stubs + 1 e2e) | `.github/workflows/ci-*.yml`, `e2e.yml` | ✅ |
| Go template: Makefile, Dockerfile, go.mod, `scaffold.sh` | `templates/go/` | ✅ |
| Go templates instantiated into 8 Go components | `components/{agent,host-api,net,healthcheck,scheduler,metadata,dns,lb}/{Makefile,Dockerfile,go.mod}` | ✅ |
| Cattle Java target draft (pom + Dockerfile) | `templates/java/` + `components/cattle/{Dockerfile,TARGET-pom.xml.draft}` | ✅ |
| `docs/ARCHITECTURE-DIFF.md` — full delta vs 1.6.30 | `docs/` | ✅ |
| `docs/QUICKSTART.md` — placeholder for GA | `docs/` | ✅ |
| `docs/SECURITY-BACKLOG.md` — inherited CVEs and hardening checklist | `docs/` | ✅ |
| `scripts/build` — top-level multi-image orchestrator | `scripts/` | ✅ |
| `scripts/seed-from-baseline` — copies upstream source into a component when ready | `scripts/` | ✅ |
| `scripts/e2e-*.sh` — placeholders, Phase 8 deliverables | `scripts/` | ✅ |

## File count

73 files outside `baseline/`, including 15 GitHub Actions workflows.

## Out of scope for Phase 1 (intentionally deferred)

- Pushing scaffold to a GitHub org → blocked on **organization name decision**
- GHCR registry creation → blocked on **org name + GHCR_TOKEN provisioning**
- Cosign keyless signing identity → blocked on **org name**
- Actually compiling any code → Phase 2 (de-Dapper + go mod tidy)
- Any modernization of cattle / Go components → Phase 3 / 4
- Validating that workflow YAML actually runs on GitHub → requires repo to be pushed first

## Two open follow-ups discovered during Phase 1

1. **`rancher/rancher-net` is suspiciously small (268 KB).** The actual
   IPsec/VXLAN code likely lives in adjacent repos (`rancher/plugin-manager`,
   `rancher/cni-driver`, etc.). Phase 5 must start with code archaeology to
   inventory the real network plane before estimating effort.

2. **`rancher/ui` default branch is being actively committed in 2026 for
   Rancher 2 UI work.** The HEAD pulled into `baseline/ui/` is NOT the 1.6
   UI. Before Phase 7 starts, identify the correct upstream ref (likely a
   2020-era SHA on `master` or a `v1.6` branch) and re-clone.

Both follow-ups are noted in the component READMEs.

## Next actionable steps (Phase 2 candidates)

The lowest-risk, most parallel-friendly Phase 2 starters:

1. **Seed `components/healthcheck/` from baseline** with `scripts/seed-from-baseline healthcheck`, then run `go mod init`, port `trash.conf` deps to `go.mod`, get `make build` green. **~1 day.** This proves the Go template + scaffold workflow end-to-end on the simplest component.

2. **Seed `components/agent/` from baseline (meta-repo's `agent/` subdir, not the rancher/agent repo)** and capture the Python 2 → 3 conversion scope. **~2 days.**

3. **Spin up `components/cattle/`**: copy `baseline/cattle/` into place, run OpenRewrite's `JavaxMigrationToJakarta` recipe in dry-run mode to size the Spring 6 migration. Outputs go to `docs/PHASE-3-ESTIMATE.md`. **~1 day.**

These three can run in parallel by 3 engineers; results inform Phase 2 effort estimate refinement.

## Decisions still pending from the user

Before Phase 2 starts the user should commit to:

- **GitHub organization name** (working title: `rancher-classic`)
- **Project name** if different from organization (UI branding, NOTICE
  attribution)
- **GHCR_TOKEN / registry permissions** provisioning
- **Engineering team assignment** (plan assumes ~2 FTE for 15 weeks)
