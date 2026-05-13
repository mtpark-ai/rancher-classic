# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] - 1.7.0-dev

### Added
- Initial fork from Rancher 1.6.30 / Cattle 0.183.52.1
- Workspace scaffold under `components/`, `baseline/`, `templates/`, `scripts/`
- CI templates for Ubuntu 24.04 + Docker 25/27 build matrix

### Changed
- Target Java 17 LTS (was 8); Spring 6.1.x (was 4.3.2); Jetty 12 (was 9.2); JOOQ 3.19 (was 3.3)
- Target Go 1.22+ (was 1.6–1.9); Docker SDK upgraded to docker/docker/client v27
- Build system: removed Dapper / Trash / Glide → standard `docker buildx` + `go mod` + Maven Wrapper

### Removed
- Kubernetes / Mesos / Swarm orchestration backends (Cattle-only)
- IPsec overlay (VXLAN-only)
- Windows agent (`rancher/win-agent`)
- Bundled MySQL inside `rancher/server` image (external DB required)
- Cloud-storage infra-templates (AWS EBS/EFS/ECR/Route53, NetApp, Portworx)
- In-place upgrade path from 1.6.x (1.7.0 is a fresh deployment)

### Security
- All baseline CVEs from frozen 2015-era dependencies are tracked in
  `docs/SECURITY-BACKLOG.md` and scheduled for resolution before GA.

[Unreleased]: https://github.com/mtpark-ai/rancher-classic/compare/HEAD...HEAD
