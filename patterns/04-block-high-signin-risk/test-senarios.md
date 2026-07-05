# Pattern 04 — Block High Sign-in Risk: Test Scenarios

**Policy:** CA04 - Block High Sign-in Risk
**State:** report-only → enforce after review
**ATT&CK:** T1090.003, T1078
**License:** P2 (Identity Protection)

| # | Scenario | Expected (enforced) |
|---|----------|---------------------|
| 1 | Sign-in over Tor / anonymous VPN | High risk → Blocked |
| 2 | Normal sign-in, no risk | Allowed |
| 3 | Medium-risk sign-in | Not blocked here (handled by CA06) |
| 4 | Break-glass account | Allowed (excluded) |

## Report-only validation
- Trigger a test: sign in via Tor Browser → check Sign-in logs → risk = high, result "would block".
- Entra → Protection → Identity Protection → Risky sign-ins to confirm detection.

## Rollback
Set `state` to `disabled`, re-run apply.