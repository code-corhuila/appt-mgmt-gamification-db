# appt-mgmt-gamification-db

Database component for Salud Activa's gamification bounded context. It stores the achievement
catalog and per-user progress used by the app's medication, health-record, and appointment
achievements.

## Repository layout

- `migrations/`: ordered PostgreSQL schema migrations.
- `seed.sql`: idempotent achievement catalog seed.
- `tests/`: schema and catalog checks using Node's built-in test runner.
- `adrs/`: architecture decisions.
- `terraform/`: private AWS RDS PostgreSQL deployment.
- `.github/workflows/quality.yml`: validation for pull requests to `develop`, `qa`, and `main`.

The database stores the identity-service user ID as an external key; it does not own user accounts.
Android-specific drawable resource IDs are intentionally not stored in the shared catalog. The app
maps each `icon_key` to a local drawable.

## Run locally

Requirements: Docker Compose and Node.js 20 or newer.

```powershell
Copy-Item .env.example .env
# Replace POSTGRES_PASSWORD with a random local-only value.
docker compose up -d
npm test
```

PostgreSQL is available on `localhost:5434` by default. Initialization runs the migration and seed
only when the database volume is first created. `docker compose down` stops the service and keeps
the volume.

## Deploy with Terraform

Use private subnets in at least two availability zones, an application security group, and a
supported PostgreSQL engine version. Supply the database password through a secret manager or
`TF_VAR_db_password`; never commit credentials or Terraform state. The database is private,
encrypted, and protected from deletion by default.

```powershell
Copy-Item terraform\terraform.tfvars.example terraform\terraform.tfvars
terraform -chdir=terraform init
terraform -chdir=terraform plan
terraform -chdir=terraform apply
```

Update the example VPC, subnet, security-group, and engine-version values before planning. Configure
an encrypted remote Terraform backend before using this outside a local evaluation.

## Contribution flow

Do not commit directly to permanent branches:

1. Create `hu-xxx-dev` from `develop` and open a PR to `develop`.
2. Promote `develop` to `qa` through a PR.
3. Promote `qa` to `main` through a PR.

Existing repository review rules and `.github/CODEOWNERS` still apply. Each contributor records
their own evidence in their fork under `NN-week/hu-status/`. Automated attribution requires the
profile repository's `CONFIG`; do not copy another contributor's status file.
