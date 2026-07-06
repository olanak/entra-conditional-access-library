# Pattern 09 — Require Approved Client Apps: Test Scenarios

**Policy:** CA09 - Require Approved Client Apps (Mobile/Desktop)
**State:** report-only (requires Intune app protection to enforce)
**ATT&CK:** T1528
**License:** P1+ with Intune

| # | Scenario | Expected (enforced, Intune tenant) |
|---|----------|-------------------------------------|
| 1 | Office 365 via Outlook mobile (approved) | Allowed |
| 2 | Office 365 via unapproved 3rd-party mail app | Blocked |
| 3 | Browser access | Out of scope (not app-protection surface) |
| 4 | Break-glass account | Allowed (excluded) |

## Lab note
No Intune app protection in this trial tenant → scenarios 1–2 can't be live-tested.
Validated by design; document behavior in an Intune-enabled tenant.

## Report-only validation (where Intune exists)
- Sign-in logs → filter Office 365 + mobile client → check approved-app evaluation.
- Confirm approved apps are deployed to users before enforcing.

## Rollback
Set `state` to `disabled`, re-run apply.