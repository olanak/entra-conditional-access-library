# Pattern 15 — Block Guest Access to Sensitive Resources: Test Scenarios

**Policy:** CA15 - Block Guest Access to Sensitive Resources
**State:** report-only → enforce after review
**ATT&CK:** T1078.003
**License:** P1+

| # | Scenario | Expected (enforced) |
|---|----------|---------------------|
| 1 | Guest user accesses Azure management API | Blocked |
| 2 | Member (internal) user accesses same | Allowed (out of scope) |
| 3 | Guest accesses an allowed collaboration app | Allowed (not in sensitive list) |
| 4 | Break-glass account | Allowed (excluded) |

## Report-only validation
- Sign-in logs → filter user type = Guest + the sensitive app → confirm "would block".
- Verify no legitimate guest workflow depends on the targeted resources before enforcing.

## Rollback
Set `state` to `disabled`, re-run apply.