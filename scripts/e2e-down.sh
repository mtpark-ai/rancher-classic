#!/usr/bin/env bash
## Tear down the e2e cluster brought up by e2e-up.sh.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

cd "$REPO_ROOT"

echo "[e2e-down] dumping cattle + agent logs for post-mortem"
mkdir -p dist/e2e-logs
docker compose -f scripts/e2e-docker-compose.yml logs cattle      > dist/e2e-logs/cattle.log    2>&1 || true
docker compose -f scripts/e2e-docker-compose.yml logs agent-1     > dist/e2e-logs/agent-1.log   2>&1 || true
docker compose -f scripts/e2e-docker-compose.yml logs agent-2     > dist/e2e-logs/agent-2.log   2>&1 || true
docker compose -f scripts/e2e-docker-compose.yml logs agent-3     > dist/e2e-logs/agent-3.log   2>&1 || true
docker compose -f scripts/e2e-docker-compose.yml logs mariadb     > dist/e2e-logs/mariadb.log   2>&1 || true

echo "[e2e-down] bringing topology down (volumes + networks)"
docker compose -f scripts/e2e-docker-compose.yml down -v --remove-orphans
