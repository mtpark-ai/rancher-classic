# components/cattle

**Language:** Java (Maven multi-module)
**Baseline:** `rancher/cattle @ v0.183.52.1` (HEAD `b5fe156`, 2020-05-13)
**Target version (1.7.0):** Java 17 LTS · Spring 6.1.x · Jetty 12.0.x · JOOQ 3.19.x · docker-java 3.4.x
**Phase:** 1 — scaffold only. No code copied yet.

## Role
The Cattle orchestration engine. Single big JAR that:
- exposes the Cattle REST API
- runs the state machine for environments, stacks, services, containers
- talks to Docker daemons on each host through `docker-java`
- persists state to external MySQL/MariaDB via JOOQ

## Modernization plan (Phase 3 of master plan)
1. **Build**: drop Dapper; multi-stage `Dockerfile` (`maven:3.9-eclipse-temurin-17` → `eclipse-temurin:17-jre-noble`)
2. **Java 17 + `javax → jakarta`** sweep via OpenRewrite
3. **Spring 4.3 → 6.1**, **Jetty 9.2 → 12.0**
4. **JOOQ 3.3 → 3.19**: regenerate codegen, accept API breakage
5. **docker-java 1.1.0 → 3.4.0**: rewrite all Docker SDK call sites; introduce `DockerClientAdapter`
6. **Strip K8s/Mesos/Swarm**: delete `code/implementation/{kubernetes,mesos,swarm}/`, their launcher resources, and `environment_template` seed rows
7. **External DB only**: remove embedded MySQL bootstrap from `scripts/build`

## Key files (in baseline) to focus on
- `code/meta-parent/pom.xml`                                      — dependencyManagement
- `code/implementation/docker/common/pom.xml`                     — docker-java coordinates
- `code/implementation/docker/compute/src/main/java/…`            — all DockerClient call sites
- `code/iaas/launcher/src/main/resources/META-INF/cattle/launcher/cattle.yml` — keep
- `code/iaas/launcher/src/main/resources/META-INF/cattle/launcher/{kubernetes,mesos,swarm}.yml` — delete
- `resources/content/db/changelog/db.changelog-master.xml`        — Liquibase changelog
