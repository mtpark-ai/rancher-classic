# Cattle (Java) build & runtime image — target for Phase 3.
#
# Builder uses Maven 3.9 on Temurin 17; runtime uses jre-noble (Ubuntu 24.04
# base with JRE 17 only). External MariaDB is required at runtime.

ARG MAVEN_IMAGE=maven:3.9-eclipse-temurin-17
ARG RUNTIME_IMAGE=eclipse-temurin:17-jre-noble

# ------------- builder -------------
FROM ${MAVEN_IMAGE} AS builder

WORKDIR /src
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
COPY code/ code/
COPY resources/ resources/

RUN --mount=type=cache,target=/root/.m2 \
    ./mvnw -B -ntp -DskipTests package

# ------------- runtime -------------
FROM ${RUNTIME_IMAGE}

LABEL org.opencontainers.image.source="https://github.com/mtpark-ai/rancher-classic"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL io.rancher.container.system="cattle"

ARG CATTLE_USER=cattle
ARG CATTLE_UID=1000
RUN groupadd -g ${CATTLE_UID} ${CATTLE_USER} \
 && useradd -m -u ${CATTLE_UID} -g ${CATTLE_USER} ${CATTLE_USER}

WORKDIR /var/lib/cattle

# Copy the assembled distribution (location TBD by Phase 3 build)
COPY --from=builder /src/code/packaging/launcher/target/cattle-launcher-*-dist/ /opt/cattle/

ENV CATTLE_HOME=/opt/cattle \
    JAVA_TOOL_OPTIONS="-XX:+UseG1GC -XX:MaxRAMPercentage=75 -XX:+ExitOnOutOfMemoryError"

USER ${CATTLE_USER}

# Cattle listens on 8080 (API) and 8088 (Hazelcast discovery)
EXPOSE 8080 8088

# External DB is REQUIRED (no embedded MySQL)
# CATTLE_DB_CATTLE_MYSQL_HOST, CATTLE_DB_CATTLE_MYSQL_PORT,
# CATTLE_DB_CATTLE_USERNAME, CATTLE_DB_CATTLE_PASSWORD must be set.

ENTRYPOINT ["/opt/cattle/bin/launch"]
