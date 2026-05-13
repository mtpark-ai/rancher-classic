# Security backlog

Inherited CVEs and known weaknesses from the 1.6.30 baseline that must be
addressed before 1.7.0 GA. This is a living document, not the final security
posture.

## Inherited high/critical CVEs (2015 – 2020 era dependencies)

| Component        | Library                       | Action      | Phase |
|------------------|-------------------------------|-------------|-------|
| cattle           | Spring Framework 4.3.x        | upgrade to 6.1.x | 3 |
| cattle           | Jetty 9.2.x                   | upgrade to 12.0.x | 3 |
| cattle           | JOOQ 3.3.x                    | upgrade to 3.19.x | 3 |
| cattle           | Jackson 2.5.x                 | upgrade to 2.17.x | 3 |
| cattle           | Hazelcast 3.8 (Java serialization) | upgrade to 5.5.x | 3 |
| cattle           | docker-java 1.1.0 (Netty fork) | replace with 3.4.x httpclient5 | 3 |
| cattle           | embedded MySQL 5.7 (CVEs)     | remove embedded DB | 3 |
| cattle           | Liquibase 3.x                 | upgrade to 4.29.x | 3 |
| agent / others   | trash-vendored Go deps (2015–2018) | full `go mod` migration | 4 |
| net              | strongSwan 5.x via vici       | remove (VXLAN only) | 5 |
| lb               | HAProxy 2.1.4                 | upgrade to 2.8 LTS | 6 |
| ui               | Ember 2.x + npm tree from 2017 | `npm audit fix` to 0 high/critical | 7 |
| ui               | jQuery (transitive)           | drop or upgrade to 3.7+ | 7 |
| ui               | phantomjs                     | replace with playwright | 7 |

## Hardening additions

| Item                                | Phase |
|-------------------------------------|-------|
| All Go images: distroless nonroot base | 2 |
| Cosign keyless signing for release images | 1 (CI ready) |
| SBOM + provenance attestations on every published image | 1 (CI ready) |
| Mandatory TLS for agent ↔ server channel (no plaintext fallback) | 4 |
| Drop `--privileged` from agent where possible (still needed for `share-mnt`) | 4 |
| Cattle DB credentials: file-based secret support (no env-only) | 3 |
| RBAC: review default environment-admin scope vs. least privilege | 3 |

## Out of scope for 1.7.0 (tracked for 1.8+)

- FIPS-validated crypto modules
- ARM64 multi-arch images
- containerd direct integration (no Docker daemon)
- mTLS for inter-stack traffic (currently only IPsec provided this; we
  removed IPsec — recommend external SDN if mTLS overlay is required)
