# Contributing

## Development setup

```bash
cd terraform
terraform init -backend=false
```

TFLint config lives in `.tflint.hcl` at the repo root.

## Branch naming

- `feat/<short-name>`
- `fix/<short-name>`
- `chore/<short-name>`
- `docs/<short-name>`
- `ci/<short-name>`

## Commits

Conventional Commits: `feat:`, `fix:`, `docs:`, `refactor:`, `chore:`, `test:`, `ci:`.

## Tests

```bash
cd terraform
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
tflint --init && tflint
# from repo root:
trivy config --severity HIGH,CRITICAL terraform
```

## Pull requests

Open against `main`. CI (`validate-and-lint`) must be green. Squash merge preferred.

Checklist:

- [ ] `terraform fmt` / `validate` / TFLint pass
- [ ] Branch naming follows convention
- [ ] Conventional commits
- [ ] Manifest / monitoring changes stay consistent with Terraform outputs
