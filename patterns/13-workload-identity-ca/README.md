# Pattern 13 — Workload Identity Conditional Access

Blocks a protected **service principal** from requesting tokens outside trusted country
locations — extending Conditional Access from users to non-human (workload) identities.

## Why
Service principals hold credentials, often have no lifecycle/owner, and can't do MFA —
making them high-value, under-managed targets. If an SP's secret leaks, an attacker can use
it from anywhere. Location-gating the SP shrinks that blast radius to trusted egress points.

**ATT&CK:** T1078.004 (Valid Accounts: Cloud Accounts)

## ⚠️ License gate — not deployed
This policy requires **Workload Identities Premium** — a standalone SKU ($3/service
principal/month) that is **not** included in Entra ID P2. Microsoft Q&A confirms P2 does not
cover it. Without the license, the Graph API rejects `client_applications`.

Status: **code-complete, validated with `terraform validate`, intentionally not applied.**
A free 90-day Workload ID trial exists; activate it and populate
`protected_service_principal_ids` to deploy for real.

## How
Targets service principals via `client_applications.included_service_principals` (not
`users`). Grant control = `block` (the only option valid for workload identities — they
cannot satisfy MFA). Reuses the trusted named location from pattern 08. A `count` guard
keeps it out of the default apply until the SP list is populated.

## Constraints (workload identity CA)
- Single-tenant service principals only. Microsoft first-party apps, multitenant apps, and
  managed identities are **not** eligible.
- Block is the only available grant control.
- SPs added to a group are not covered by group-scoped policy — they must be assigned directly.

## License
Entra ID **P1+** for CA, **plus Workload Identities Premium** for the SP scope.

## Files
`../../terraform/13-workload-identity-ca.tf` · `test-scenarios.md`

## Deploy (only with Workload ID license)
```bash
# populate protected_service_principal_ids in terraform.tfvars first
terraform apply -target=azuread_conditional_access_policy.ca13_workload_identity_location
```