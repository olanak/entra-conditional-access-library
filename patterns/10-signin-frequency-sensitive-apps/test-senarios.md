# Pattern 10 — Sign-in Frequency for Sensitive Apps: Test Scenarios

**Policy:** CA10 - Sign-in Frequency for Sensitive Apps
**State:** report-only → enforce after review
**ATT&CK:** T1550.001
**License:** P1+

| # | Scenario | Expected (enforced) |
|---|----------|---------------------|
| 1 | Access Azure portal, session < 4h old | Allowed, no prompt |
| 2 | Access Azure portal, session > 4h old | Re-authentication required |
| 3 | Access a non-sensitive app | Out of scope, normal lifetime |
| 4 | Break-glass account | Allowed (excluded) |

## Report-only validation
- Sign-in logs → filter the sensitive app → confirm sign-in-frequency evaluation appears.
- Note: report-only shows policy application; the 4h re-auth is only observable when enforced.

## Rollback
Set `state` to `disabled`, re-run apply.