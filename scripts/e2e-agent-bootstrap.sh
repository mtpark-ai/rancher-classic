#!/bin/sh
## Inside each DinD agent host:
##   1. start the host's dockerd
##   2. fetch the bootstrap.sh from Cattle (server-generated, includes
##      registration token + agent image ref)
##   3. exec the bootstrap (runs rancher-classic-agent with privileged
##      Docker access via /var/run/docker.sock)
##
## This file is volume-mounted from scripts/ into the DinD container.

set -e

dockerd-entrypoint.sh &
DOCKERD_PID=$!

i=0
until docker info >/dev/null 2>&1; do
    i=$((i + 1))
    if [ "$i" -gt 30 ]; then
        echo "dockerd did not become ready in 30s" >&2
        exit 1
    fi
    sleep 1
done

echo "[$AGENT_NAME] dockerd up. registering with $CATTLE_URL"

i=0
until curl -fsSL "$CATTLE_URL/" >/dev/null 2>&1; do
    i=$((i + 1))
    if [ "$i" -gt 60 ]; then
        echo "cattle server did not respond in 60s" >&2
        exit 1
    fi
    sleep 1
done

## Fetch the bootstrap script that Cattle generates per environment.
## In a fresh server, the default project's registration token is
## reachable via /v1/registrationTokens; for e2e we use the
## auto-generated default-environment token.
TOKEN=$(curl -fsSL "$CATTLE_URL/registrationTokens?state=active" \
    | grep -oE '"token":"[^"]+"' | head -1 | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
    echo "could not obtain registration token" >&2
    exit 1
fi

curl -fsSL "$CATTLE_URL/scripts/${TOKEN}/bootstrap" | sh

## Keep the container alive while the agent talks to Cattle.
wait $DOCKERD_PID
