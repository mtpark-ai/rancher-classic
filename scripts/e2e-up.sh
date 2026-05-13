#!/usr/bin/env bash
## Bring up a 1-server + 3-agent rancher-classic cluster using
## docker-in-docker for the agent hosts. Used by .github/workflows/e2e.yml.
##
## Phase 1 placeholder: only prints the intended topology. Actual logic
## lands in Phase 8.

set -euo pipefail

TAG="${1:-dev}"
DOCKER_VERSION="${2:-27}"

cat <<EOF
[e2e-up] planned topology
  - rancher-classic-server:$TAG  (ports 8080, 8088)  + external mariadb:10.11
  - rancher-classic-agent:$TAG   x3 in dind:$DOCKER_VERSION-dind containers
                                 each joined to the server via bootstrap script

[e2e-up] not yet implemented (Phase 8 deliverable)
EOF
exit 0
