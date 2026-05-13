#!/usr/bin/env bash
## Bring up the e2e cluster (1 cattle server + external mariadb +
## 3 DinD agents) from scripts/e2e-docker-compose.yml.
##
## Usage: scripts/e2e-up.sh <image-tag> <docker-version>

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TAG="${1:-e2e}"
DOCKER_VERSION="${2:-27}"

cd "$REPO_ROOT"

export TAG DOCKER_VERSION

echo "[e2e-up] using cattle image tag: $TAG  /  agent docker version: $DOCKER_VERSION"
echo "[e2e-up] bringing up topology"
docker compose -f scripts/e2e-docker-compose.yml up -d

echo "[e2e-up] waiting for cattle to report healthy (max 5 min)"
for i in $(seq 1 60); do
    state=$(docker compose -f scripts/e2e-docker-compose.yml ps --format json cattle 2>/dev/null \
        | grep -oE '"Health":"[a-z]+"' | head -1 | cut -d'"' -f4)
    case "$state" in
        healthy) echo "[e2e-up] cattle healthy at attempt $i"; exit 0 ;;
        unhealthy) echo "[e2e-up] cattle unhealthy"; docker compose -f scripts/e2e-docker-compose.yml logs cattle | tail -50; exit 1 ;;
    esac
    sleep 5
done

echo "[e2e-up] cattle did not become healthy within 5 min"
docker compose -f scripts/e2e-docker-compose.yml logs --tail=50
exit 1
