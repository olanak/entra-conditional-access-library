# Pattern 02 — Require MFA (All Users): Test Scenarios

**Policy:** CA02 - Require MFA for All Users
**State:** report-only → enforce after 7 clean days
**ATT&CK:** T1078 (Valid Accounts)

| # | Scenario | Expected (enforced) |
|---|----------|---------------------|
| 1 | User signs in, no MFA registered | Prompted to register/complete MFA |
| 2 | User with MFA | Allowed after MFA |
| 3 | Break-glass account | Allowed (excluded) |
| 4 | Legacy client | Already blocked by CA01 |

## Report-only validation
- Entra → CA → CA02 → Insights & reporting; confirm sign-ins "would require MFA".
- Ensure all real users can register MFA before enforcing.

## Rollback
Set `state` to `disabled`, re-run `deploy.ps1`.