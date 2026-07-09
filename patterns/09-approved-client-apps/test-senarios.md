# Pattern 09 — Require App Protection Policy: Test Scenarios

**Policy:** CA09 - Require App Protection Policy (Mobile)
**State:** report-only (requires Intune app protection to enforce)
**ATT&CK:** T1528
**License:** P1+ with Intune
**Grant control:** `compliantApplication` (Require app protection policy). The legacy
`approvedApplication` grant retired 30 June 2026 and is not used.

| # | Scenario | Expected (enforced, Intune tenant) |
|---|----------|-------------------------------------|
| 1 | Office 365 via Outlook mobile with app protection policy | Allowed |
| 2 | Office 365 via app without app protection policy | Blocked |
| 3 | Browser access | Out of scope (not app-protection surface) |
| 4 | Break-glass account | Allowed (excluded) |

## Lab note
No Intune app protection in this trial tenant → scenarios 1–2 can't be live-tested.
Validated by design; document behavior in an Intune-enabled tenant.

## Report-only validation (where Intune exists)
- Sign-in logs → filter Office 365 + mobile client → check app-protection-policy evaluation.
- Confirm app protection policies are assigned and a broker app is present before enforcing.

## Rollback
Set `state` to `disabled`, re-run apply.