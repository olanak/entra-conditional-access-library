# Pattern 03 — Phishing-Resistant MFA (Admins): Test Scenarios

**Policy:** CA03 - Phishing-Resistant MFA for Admins
**State:** report-only → enforce after admins enroll FIDO2/WHfB
**ATT&CK:** T1621, T1566
**License:** P1+

| # | Scenario | Expected (enforced) |
|---|----------|---------------------|
| 1 | Admin with FIDO2 / WHfB / cert | Allowed |
| 2 | Admin with only SMS or app-push MFA | Blocked (not phishing-resistant) |
| 3 | Non-admin user | Out of scope |
| 4 | Break-glass account | Allowed (excluded) |

## Report-only validation
- Confirm all admins have a phishing-resistant method registered BEFORE enforcing.
- Entra → CA → CA03 → Insights & reporting: verify no admin would be locked out.
- Sign-in logs → filter by an admin account → check auth-strength evaluation.

## Rollback
Set `state` to `disabled`, re-run apply.