# Pattern 06 — Medium Sign-in Risk: Test Scenarios

**Policy:** CA06 - Medium Sign-in Risk - Require MFA
**State:** report-only → enforce after review
**ATT&CK:** T1078
**License:** P2

| # | Scenario | Expected (enforced) |
|---|----------|---------------------|
| 1 | Medium-risk sign-in (unfamiliar location) | Prompted for MFA |
| 2 | High-risk sign-in | Blocked by CA04 (not this policy) |
| 3 | No-risk sign-in | Allowed, no prompt |
| 4 | Break-glass account | Allowed (excluded) |

## Report-only validation
- Sign-in logs → filter sign-in risk = medium → confirm "would require MFA".
- Ensure users have MFA registered so remediation can succeed.

## Rollback
Set `state` to `disabled`, re-run apply.