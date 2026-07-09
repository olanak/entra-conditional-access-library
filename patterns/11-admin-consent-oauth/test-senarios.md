# Pattern 11 — Require Admin Consent: Test Scenarios

**Control:** Tenant authorization policy (user consent disabled)
**Deployed via:** Graph PowerShell (not CA)
**ATT&CK:** T1528

| # | Scenario | Expected |
|---|----------|----------|
| 1 | User tries to consent to a new OAuth app | Blocked — "needs admin approval" |
| 2 | Admin consents to the same app | Allowed |
| 3 | User submits an admin consent request (if workflow enabled) | Routed to reviewer |
| 4 | Previously consented apps | Unaffected (existing grants remain) |

## Validation
- `./deploy-admin-consent.ps1 -Report` → confirm `PermissionGrantPoliciesAssigned` is empty.
- Portal: Entra → Enterprise applications → Consent and permissions → User consent settings → "Do not allow user consent".
- Attempt a consent as a non-admin test user → expect the approval-required prompt.

## Rollback
See README — re-assign `ManagePermissionGrantsForSelf.microsoft-user-default-low`.