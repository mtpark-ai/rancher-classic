# cattle — Phase 3 status

## Phase 2 status

The cattle baseline has been **seeded** from `rancher/cattle@v0.183.52.1`
(HEAD `b5fe156`). Phase 2 did not perform any code-level migration; only:

- removed `Dockerfile.dapper` (Dockerfile.template now provides a
  Java-17 + Maven-3.9 multi-stage build at `components/cattle/Dockerfile`)
- left `TARGET-pom.xml.draft` in place as the version-bump reference
- did **not** run `mvn package` or `OpenRewrite`
- did **not** modify any `.java` source

The current Java tree compiles with **Java 8 / Spring 4.3 / Jetty 9.2 /
JOOQ 3.3** (the 2020 baseline). It does **not** compile with the
Java 17 / Spring 6 / Jetty 12 / JOOQ 3.19 target stack documented in
`TARGET-pom.xml.draft`.

## Phase 3 — concrete deliverables

These are the things Phase 3 must do, in roughly this order:

### 1. Build-system modernization (≈ 0.5 pw)
- Upgrade Maven Wrapper to 3.9.x
- Change `code/meta-parent/pom.xml`:
  - `maven.compiler.source/target` = 8 → 17 (then 17 → `release` flag)
  - Bump `maven-compiler-plugin`, `maven-surefire-plugin`,
    `maven-failsafe-plugin` to current
- Replace `embedded-jmxtrans` and `logback-gelf` (legacy observability)
  with Micrometer + stdlib logback

### 2. javax → jakarta sweep (≈ 1.0 pw)
The largest mechanical change. Run OpenRewrite recipes in this order:
1. `org.openrewrite.java.migrate.UpgradeToJava17`
2. `org.openrewrite.java.migrate.jakarta.JavaxMigrationToJakarta`
3. `org.openrewrite.java.spring.framework.UpgradeSpringFramework_6_0`

Expected diff size: 1500+ lines across `javax.servlet.*`,
`javax.annotation.*`, `javax.inject.*`, `javax.persistence.*`.

### 3. Spring 4.3 → 6.1 (≈ 1.0 pw)
After OpenRewrite, hand-resolve:
- `XmlWebApplicationContext` → `AnnotationConfigWebApplicationContext`
- `SimpleJdbcCall` → JdbcClient
- Removed `org.springframework.transaction.annotation.IsolationLevel`
- Bean post-processors that used `ClassPathBeanDefinitionScanner` directly

### 4. Jetty 9.2 → 12.0 (≈ 0.5 pw)
- `org.eclipse.jetty.servlet` → `org.eclipse.jetty.ee10.servlet`
- `WebAppContext` lifecycle changes
- TLS config moved (`SslContextFactory` → `SslContextFactory.Server`)

### 5. JOOQ 3.3 → 3.19 (≈ 0.5 pw)
- Re-run `jooq-codegen` against a clean MariaDB 10.11 instance
- API renames: `Factory` → `DSLContext`, `selectFrom` returns differ
- Test data fixtures still use H2 in some places — switch to
  testcontainers MariaDB

### 6. docker-java 1.1.0 → 3.4.0 (≈ 0.5 pw)
- `code/implementation/docker/common/pom.xml`: bump coordinates
- `code/implementation/docker/compute/src/main/java/...`: rewrite
  every `DockerClient` call site (builders, HostConfig, streams)
- Switch transport to `docker-java-transport-httpclient5`

### 7. Strip K8s/Mesos/Swarm references (≈ 0.5 pw)
Inline references to these orchestration backends exist in 13 files:
```
code/iaas/model/src/main/java/io/cattle/platform/core/constants/AccountConstants.java
code/iaas/model/src/main/java/io/cattle/platform/core/constants/ServiceConstants.java
code/iaas/api-logic/src/main/java/io/cattle/platform/iaas/api/filter/compat/CompatibilityOutputFilter.java
code/iaas/api-logic/src/main/java/io/cattle/platform/iaas/api/manager/ServiceManager.java
code/iaas/api-logic/src/main/java/io/cattle/platform/iaas/api/request/handler/RequestReRouterHandler.java
code/iaas/config-item/server/src/main/java/io/cattle/platform/configitem/context/data/metadata/common/ServiceMetaData.java
code/iaas/logic/src/main/java/io/cattle/platform/process/externalevent/ExternalServiceEventCreate.java
code/iaas/logic/src/main/java/io/cattle/platform/process/instance/K8sPreInstanceCreate.java
code/implementation/sample-setup/src/main/java/io/cattle/platform/sample/data/SampleDataStartupV11.java
code/implementation/sample-setup/src/main/java/io/cattle/platform/sample/data/SampleDataStartupV13.java
code/implementation/system-stack/src/main/java/io/cattle/platform/systemstack/process/SystemStackRemovePostHandler.java
code/packaging/app-config/src/main/java/io/cattle/platform/app/CoreModelConfig.java
code/packaging/app-config/src/main/resources/META-INF/cattle/process/spring-process-context.xml
```

For each: delete the K8s/Mesos/Swarm branches; keep only Cattle.
`K8sPreInstanceCreate` can be deleted entirely.

DB schema: remove `environment_template` seed rows that bootstrap
K8s/Mesos/Swarm orchestration types from
`resources/content/db/changelog/`. **Be very careful** — touching
Liquibase changesets in-place is destructive on existing databases.
1.7.0 is documented as no-upgrade-from-1.6 so creating a clean
changelog is acceptable.

### 8. External-only DB (≈ 0.5 pw)
- `scripts/build`: stop installing `mysql-server` into the image
- Validate failure mode when `CATTLE_DB_CATTLE_MYSQL_HOST` is unset
- Update QUICKSTART.md to reflect the new requirement (already done)

## CI status

`ci-cattle` workflow exists with `_reusable-java-ci.yml`. It will fail
until at least steps 1 + 6 above are complete. Until then the workflow
is **advisory** (the rancher-classic main branch is not gated on it).

## Recommended Phase 3 starting move

A single engineer can productively start by:

1. **Cloning the workspace locally** and running
   `cd components/cattle && ./mvnw -B -ntp -DskipTests compile` against
   the seeded Java-8 baseline to verify it still builds as-is.
2. **Running OpenRewrite in dry-run mode** against the baseline:
   ```
   ./mvnw -Drewrite.activeRecipes=org.openrewrite.java.migrate.UpgradeToJava17 \
          org.openrewrite:rewrite-maven-plugin:dryRun
   ```
   This produces `target/site/rewrite/rewrite.patch`. The patch's
   line count is the truest sizing of step 2.
3. **Bumping `maven.compiler.release` to 17** without changing any
   source, running `mvn compile`, capturing the first ~50 errors —
   these are the load-bearing change targets.

After this scouting, Phase 3 split into a 4-week project plan with
concrete file ownership becomes possible.
