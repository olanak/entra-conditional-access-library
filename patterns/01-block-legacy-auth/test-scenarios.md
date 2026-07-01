# Pattern 01 — Block Legacy Auth: Test Scenarios

**Policy:** CA01 - Block Legacy Authentication
**State:** report-only → enforce after 7 days of clean logs
**ATT&CK:** T1110 (Brute Force / Password Spray)

## Tests

| # | Scenario | Expected (enforced) |
|---|----------|---------------------|
| 1 | Sign in via modern auth (browser/Office) | Allowed — not in scope |
| 2 | Legacy client (IMAP/POP/SMTP AUTH) | Blocked |
| 3 | Old Office / ActiveSync basic auth | Blocked |
| 4 | Break-glass account via legacy | Allowed (excluded) |

## Report-only validation (before enforcing)
- Entra → CA → Policy → **Insights & reporting**; confirm legacy sign-ins show "would be blocked".
- Sign-in logs → filter **Client app = legacy**; check who'd be impacted.
- Zero legitimate users hit → flip `state` to `enabled`.

## Rollback
Set `state` to `disabled` (or `enabledForReportingButNotEnforced`), re-run `deploy.ps1`.