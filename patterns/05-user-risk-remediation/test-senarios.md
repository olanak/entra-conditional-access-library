# Pattern 05 — High User Risk: Test Scenarios

**Policy:** CA05 - High User Risk - Require Password Change
**State:** report-only → enforce after review
**ATT&CK:** T1078
**License:** P2

| # | Scenario | Expected (enforced) |
|---|----------|---------------------|
| 1 | User flagged high risk (leaked creds) | Forced MFA + password change |
| 2 | Normal user, no risk | Allowed |
| 3 | High-risk user completes password change | Risk cleared, access restored |
| 4 | Break-glass account | Allowed (excluded) |

## Report-only validation
- Entra → Protection → Identity Protection → Risky users; confirm high-risk users would be prompted.
- (Test) mark a test user's risk high via the portal → check policy evaluation in Sign-in logs.

## Rollback
Set `state` to `disabled`, re-run apply.