#!/usr/bin/env bash
## Curl through the LB to assert the nginx-stack is reachable and that
## traffic is balancing across all 3 replicas.

set -euo pipefail

LB_URL="${LB_URL:-http://127.0.0.1:8081/}"

echo "[e2e-assert] verifying LB reachable at $LB_URL"
http_code=$(curl -fsSL -o /dev/null -w '%{http_code}' "${LB_URL}") || true
if [ "$http_code" != "200" ]; then
    echo "LB returned HTTP $http_code — expected 200"
    exit 1
fi

## Distinct container IDs over 30 requests — should hit ≥2 different
## replicas if VXLAN + LB are working correctly.
declare -A seen
for _ in $(seq 1 30); do
    id=$(curl -fsSL "${LB_URL}/__rancher-classic-canary" -o /dev/null -w '%{header.server}' 2>/dev/null || true)
    [ -n "$id" ] && seen["$id"]=1
done

if [ ${#seen[@]} -lt 2 ]; then
    echo "[e2e-assert] only saw ${#seen[@]} distinct backends — LB or VXLAN not balancing"
    exit 1
fi

echo "[e2e-assert] LB balanced across ${#seen[@]} backends — OK"
