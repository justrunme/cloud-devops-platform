# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-10-10

### Added

- `.gitignore` for Terraform state, provider binaries, kubeconfig, and scan outputs
- `SECURITY.md` with private reporting via GitHub Security Advisories
- Monthly grouped Dependabot updates for Terraform providers and GitHub Actions
- CI checks for `terraform fmt -check`, `terraform validate`, TFLint, and Trivy config policy scanning

### Changed

- Removed committed Terraform state, `.terraform/` provider binaries, and related artifacts
- Updated Terraform CLI, providers (kind, kubernetes, helm, local), Kind node image (Kubernetes 1.37), and Argo CD / Prometheus / Grafana Helm chart versions
- Hardened GitHub Actions workflow by removing failure-masking patterns and upgrading actions
- Aligned README with the Kind-based stack implemented in this repository
