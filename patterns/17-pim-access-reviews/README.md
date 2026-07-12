# Pattern 17 — PIM Access Reviews for Privileged Roles

Creates a recurring access review that forces periodic re-attestation of who holds a
privileged role (default: Global Administrator).

## Why
Privileged access accumulates: people change teams, projects end, but the admin role stays.
This "privilege creep" is a standing risk. Recurring access reviews make someone confirm, on
a schedule, that each holder still needs the role — and automatically remove those who don't
(or aren't reviewed). It's the governance backstop to just-in-time activation (pattern 16).

**ATT&CK:** T1098 (Account Manipulation), privilege-creep reduction

## Why PowerShell (not Terraform)
Access review definitions are an Identity Governance Graph API surface not modelled by the
`azuread` provider — same routing decision as patterns 11 and 16.

## How
Creates an `accessReviewScheduleDefinition` scoped to the role's PIM-managed assignments,
recurring (default monthly), 7-day instances, with **auto-apply** and **default decision =
Deny** so unreviewed access is removed automatically.

## Production note
This template uses self-review (assignees review themselves) for lab simplicity. In
production, set explicit reviewers (a security team / manager) rather than self-attestation.

## License
Entra ID **P2** (PIM / access reviews).

## Files
`../../scripts/pim/create-access-review.ps1` · `test-scenarios.md`

## Deploy
```powershell
./scripts/pim/create-access-review.ps1
# custom role / cadence:
./scripts/pim/create-access-review.ps1 -RoleTemplateId <id> -RoleName "Security Administrator" -Recurrence quarterly
```

## Rollback
```powershell
# find and remove the review definition
Get-MgIdentityGovernanceAccessReviewDefinition -Filter "displayName eq 'Access Review - Global Administrator (PIM)'"
Remove-MgIdentityGovernanceAccessReviewDefinition -AccessReviewScheduleDefinitionId <id>
```