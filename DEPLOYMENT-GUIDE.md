# Deployment Guide

How to deploy any pattern safely. _Skeleton — expanded at project completion._

## Prerequisites

- Entra tenant with **P1** (P2 for patterns 04–06); see [`docs/prerequisites.md`](docs/prerequisites.md).
- Two break-glass Global Admin accounts created and excluded ([`docs/break-glass-accounts.md`](docs/break-glass-accounts.md)).
- Terraform and Azure CLI authenticated to the tenant (`az login --tenant <id>`).
- `terraform/terraform.tfvars` populated (`tenant_id`, `break_glass_object_ids`).

## The lifecycle: report-only → pilot → enforce

1. **Report-only** — all patterns ship as `enabledForReportingButNotEnforced`.
   Deploy: `terraform apply`.
2. **Review (~7 days)** — Entra → Conditional Access → *Insights and reporting*, and Sign-in logs.
   Confirm no legitimate user or admin would be blocked.
3. **Pilot (optional)** — scope to a test group before all-users enforcement.
4. **Enforce** — change `state` to `enabled` in the pattern's `.tf`, then re-apply.

## Rollback

Set the policy `state` to `disabled` (or back to report-only) and run `terraform apply`.
Terraform state tracks every policy; `terraform destroy -target=<resource>` removes one.

## Verification

```powershell
Get-MgIdentityConditionalAccessPolicy | Select-Object DisplayName, State
```

_TODO: per-pattern enforcement checklists, Intune/PIM-specific prerequisites, CI gating._