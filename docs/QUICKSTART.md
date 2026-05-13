# Quickstart — rancher-classic 1.7.0

> **Phase 1 placeholder.** Real, working commands land at Phase 8 (e2e green).
> The shape below is what we are committing to support.

## Prerequisites

- Ubuntu 24.04 LTS host (or pair of hosts)
- Docker Engine 25.x or 27.x installed
- An external MariaDB 10.11+ or MySQL 8.0+ instance reachable from the
  rancher-classic server host
- Kernel ≥ 6.5 (for in-tree VXLAN ECN + nftables stability)

## 1. Start the server

```sh
docker run -d --restart=unless-stopped \
    -p 8080:8080 -p 8088:8088 \
    -e CATTLE_DB_CATTLE_MYSQL_HOST=db.internal \
    -e CATTLE_DB_CATTLE_MYSQL_PORT=3306 \
    -e CATTLE_DB_CATTLE_MYSQL_NAME=cattle \
    -e CATTLE_DB_CATTLE_USERNAME=cattle \
    -e CATTLE_DB_CATTLE_PASSWORD=*** \
    --name rancher-classic-server \
    ghcr.io/mtpark-ai/rancher-classic/server:1.7.0
```

## 2. Add a host

In the UI: **Infrastructure → Hosts → Add Host**, copy the docker-run
command, and execute it on the target host. It will pull
`ghcr.io/mtpark-ai/rancher-classic/agent:1.7.0` and register.

## 3. First stack

```yaml
# docker-compose.yml
version: "2"
services:
  web:
    image: nginx:alpine
    ports: ["80"]
    labels:
      io.rancher.container.pull_image: always
```

```yaml
# rancher-compose.yml
version: "2"
services:
  web:
    scale: 3
    health_check:
      port: 80
      interval: 5000
      response_timeout: 3000
      unhealthy_threshold: 3
```

Deploy with the `rancher` CLI:

```sh
rancher --url http://rancher.internal:8080 \
        up --stack my-web -d
```

## 4. Add an LB in front

```yaml
lb:
  image: ghcr.io/mtpark-ai/rancher-classic/lb:1.7.0
  ports: ["80:80/tcp"]
  labels:
    io.rancher.container.create_agent: "true"
    io.rancher.container.agent.role: environmentAdmin
```

## Troubleshooting

- **Server stuck on "waiting for database"**: confirm DB host reachable,
  user has `ALL PRIVILEGES` on the `cattle` database
- **Agent doesn't register**: ensure host can reach server's port 8080
  AND port 8088; check `docker logs -f rancher-classic-agent`
- **Cross-host VXLAN not flowing**: confirm UDP/4789 open between hosts;
  `nft list ruleset` should show `rancher-classic-vxlan` chain

See [`docs/ARCHITECTURE-DIFF.md`](ARCHITECTURE-DIFF.md) for the full delta
against legacy Rancher 1.6.30.
