#!/usr/bin/env bash
## Deploy a 3-replica nginx-stack to the e2e cluster.
##
## - Posts the stack via Cattle's POST /v2-beta/stacks API
## - Returns once all 3 services report state=active

set -euo pipefail

CATTLE_URL="${CATTLE_URL:-http://127.0.0.1:8080/v2-beta}"

STACK_NAME="${STACK_NAME:-e2e-nginx}"

read -r -d '' STACK_JSON <<EOF || true
{
  "name": "${STACK_NAME}",
  "description": "e2e nginx stack — 3 replicas, VXLAN overlay, HAProxy front",
  "system": false,
  "startOnCreate": true,
  "dockerCompose": "version: '2'\nservices:\n  web:\n    image: nginx:alpine\n    labels:\n      io.rancher.container.pull_image: always\n      io.rancher.scheduler.affinity:host_label: 'role=agent'\n    ports: ['80']\n  lb:\n    image: ghcr.io/mtpark-ai/rancher-classic/lb:${TAG:-e2e}\n    ports: ['8081:80/tcp']\n",
  "rancherCompose": "version: '2'\nservices:\n  web:\n    scale: 3\n    health_check:\n      port: 80\n      interval: 5000\n      response_timeout: 3000\n      unhealthy_threshold: 3\n  lb:\n    scale: 1\n"
}
EOF

echo "[e2e-deploy] POST ${CATTLE_URL}/stacks (${STACK_NAME})"
http_code=$(curl -fsSL -o /tmp/stack-response.json -w '%{http_code}' \
    -H 'Content-Type: application/json' \
    -X POST "${CATTLE_URL}/stacks" \
    --data "${STACK_JSON}") || {
    echo "stack create failed (HTTP $http_code):"
    cat /tmp/stack-response.json
    exit 1
}

echo "[e2e-deploy] stack created. waiting up to 5 min for services to be active"
for i in $(seq 1 60); do
    states=$(curl -fsSL "${CATTLE_URL}/stacks?name=${STACK_NAME}" \
        | grep -oE '"state":"[a-z]+"' | sort | uniq -c)
    echo "  [$i] $states"
    if echo "$states" | grep -q 'active' && ! echo "$states" | grep -qE 'updating|activating'; then
        echo "[e2e-deploy] stack active"
        exit 0
    fi
    sleep 5
done

echo "[e2e-deploy] stack did not converge to active within 5 min"
exit 1
