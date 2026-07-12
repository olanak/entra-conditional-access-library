# Pattern 17 — PIM Access Reviews: Test Scenarios

**Control:** Access review schedule definition (Graph, Identity Governance)
**ATT&CK:** T1098
**License:** P2

| # | Scenario | Expected |
|---|----------|----------|
| 1 | Review instance starts on schedule | Reviewers notified by email |
| 2 | Reviewer approves a holder | Access retained |
| 3 | Reviewer denies a holder | Access removed on auto-apply |
| 4 | Reviewer does not respond | Default decision (Deny) auto-applied |

## Validation
- Portal: Entra → Identity Governance → Access reviews → confirm "Access Review - Global Administrator (PIM)" exists with the expected recurrence.
- `Get-MgIdentityGovernanceAccessReviewDefinition -Filter "displayName eq 'Access Review - Global Administrator (PIM)'"`.
- Optionally start an on-demand instance to see reviewer notifications.

## Rollback
Remove the review definition (see README).