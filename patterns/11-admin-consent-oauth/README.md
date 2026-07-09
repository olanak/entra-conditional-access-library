# Pattern 11 — Require Admin Consent for OAuth Apps

Disables end-user consent tenant-wide so only administrators can grant OAuth application
permissions.

## Why
In an illicit consent grant attack, an attacker registers a malicious OAuth app and phishes
a user into "consenting" — handing over mailbox, file, or directory access with no password
or MFA involved. Requiring admin consent removes users' ability to approve these apps.

**ATT&CK:** T1528 (Steal Application Access Token)

## Why this is not Terraform
This is a tenant-wide **authorization policy** setting, not a Conditional Access policy.
The `azuread` provider has no resource for it (provider issues #902, #1183 remain open), so
it is deployed via Microsoft Graph PowerShell — the same routing decision as the PIM patterns.

## How
`Update-MgPolicyAuthorizationPolicy` sets `DefaultUserRolePermissions.PermissionGrantPoliciesAssigned`
to an empty array (user consent off). Pair with an **admin consent request workflow** so users
can still *request* apps for admin approval.

## License
Entra ID **P1+** (admin consent workflow); the consent setting itself is available broadly.

## Files
`../../scripts/consent/deploy-admin-consent.ps1` · `test-scenarios.md`

## Deploy
```powershell
# review current state first
./scripts/consent/deploy-admin-consent.ps1 -Report
# apply
./scripts/consent/deploy-admin-consent.ps1
```
No report-only mode exists for this setting — use `-Report` to inspect before applying, and
the rollback below to revert.

## Rollback
Re-assign the default user consent policy:
```powershell
Update-MgPolicyAuthorizationPolicy -DefaultUserRolePermissions @{
  PermissionGrantPoliciesAssigned = @("ManagePermissionGrantsForSelf.microsoft-user-default-low")
}
```