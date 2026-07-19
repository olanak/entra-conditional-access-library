# Deployment Guide

How to deploy any pattern in this library safely.

## Prerequisites

- Entra tenant with **P1** (P2 for patterns 04–06 and 16–17); see [`docs/prerequisites.md`](docs/prerequisites.md).
- Two break-glass Global Administrator accounts, created and excluded before any policy ([`docs/break-glass-accounts.md`](docs/break-glass-accounts.md)).
- Security Defaults **disabled** (mutually exclusive with Conditional Access).
- Terraform (>= 1.5) and Azure CLI authenticated to the tenant.
- PowerShell 7 with the Microsoft.Graph modules for the non-Terraform patterns (11, 16, 17).
- `terraform/terraform.tfvars` populated: `tenant_id`, `break_glass_object_ids`.

## Authentication

Terraform's `azuread` provider authenticates through the Azure CLI session:

```bash
az login --tenant <your-tenant-id>
```

Confirm the target tenant before applying — the provider deploys to whatever tenant the CLI
is signed into.

The Graph PowerShell patterns (11, 16, 17) need a directly-connected session with the right
scopes. Sign in with a native member account (not a guest) so high-privilege scopes attach:

```powershell
Connect-MgGraph -Scopes "Policy.ReadWrite.ConditionalAccess","RoleManagementPolicy.ReadWrite.Directory","AccessReview.ReadWrite.All" -UseDeviceAuthentication
(Get-MgContext).Scopes   # verify the scope attached
```

## The lifecycle: report-only → review → pilot → enforce

1. **Report-only.** All Conditional Access patterns ship as `enabledForReportingButNotEnforced`.

   ```bash
   cd terraform
   terraform init
   terraform plan
   terraform apply
   ```

   Deploy one pattern at a time when validating:

   ```bash
   terraform apply -target=azuread_conditional_access_policy.ca01_block_legacy_auth
   ```

2. **Review (about 7 days).** Let real sign-in traffic accumulate, then inspect:
   - Entra → Conditional Access → (policy) → **Insights and reporting** (the report-only workbook).
   - Entra → Monitoring → **Sign-in logs** → Conditional Access / Report-only tabs.
   - The Sentinel detections in [`docs/monitoring.md`](docs/monitoring.md).

   Look for legitimate users or admins who *would* be blocked. Each is either an intended
   exclusion or a signal the policy is too broad.

3. **Pilot (optional).** For a broad policy, scope enforcement to a small test group first
   and confirm real behaviour matches the report-only prediction.

4. **Enforce.** Change `state` to `enabled` in the pattern's `.tf`, then re-apply:

   ```hcl
   state = "enabled"
   ```

   ```bash
   terraform apply -target=azuread_conditional_access_policy.<name>
   ```

## Non-Terraform patterns

- **Pattern 11 (admin consent):** run `scripts/consent/deploy-admin-consent.ps1`. No report-only mode exists; use `-Report` to inspect before applying.
- **Patterns 16–17 (PIM):** run the scripts in `scripts/pim/`. These modify existing PIM policy rules and create access-review definitions; there is no report-only mode, so review the intended change before running.

## Pattern-specific prerequisites

- **07 compliant device / 09 app protection** — require Microsoft Intune to evaluate; deploy report-only, do not enforce without a satisfying device / app protection policy.
- **13 workload identity** — requires Workload Identities Premium (separate SKU). Code-complete; not deployed without the license.
- **08 location / 12 registration** — depend on the `Allowed Countries` named location; confirm your own country is included before enforcing.
- **04–06 risk / 16–17 PIM** — require Entra ID P2.

## Rollback

Set the policy `state` to `disabled` (or back to `enabledForReportingButNotEnforced`) and
re-apply. Terraform state tracks every policy; `terraform destroy -target=<resource>` removes
one. For the PowerShell patterns, each script's README documents the specific revert command.

## Verification

```powershell
Get-MgIdentityConditionalAccessPolicy | Select-Object DisplayName, State

# Confirm break-glass exclusion on a specific policy
(Get-MgIdentityConditionalAccessPolicy -ConditionalAccessPolicyId <id>).Conditions.Users.ExcludeUsers
```

Conditional Access changes take effect within minutes; existing sessions are re-evaluated
according to each policy's session controls.

## Continuous integration

Every push and pull request runs `terraform fmt -check`, `terraform validate`, and
PSScriptAnalyzer via GitHub Actions (`.github/workflows/`). Validation runs with
`-backend=false` and needs no tenant credentials, so it is safe on forks and pull requests.