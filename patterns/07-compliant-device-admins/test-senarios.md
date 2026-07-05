# Pattern 07 — Require Compliant Device (Admins): Test Scenarios

**Policy:** CA07 - Require Compliant Device for Admins
**State:** report-only (do NOT enforce without Intune)
**ATT&CK:** T1078.004
**License:** P1+ (requires Intune/hybrid join to evaluate)

| # | Scenario | Expected (enforced, Intune tenant) |
|---|----------|-------------------------------------|
| 1 | Admin on Intune-compliant device | Allowed |
| 2 | Admin on hybrid-joined device | Allowed |
| 3 | Admin on unmanaged/personal device | Blocked |
| 4 | Break-glass account | Allowed (excluded) |

## Lab note
No Intune in this trial tenant → scenarios 1–3 can't be live-tested here. Validated by design; document behavior when moved to an Intune-enabled tenant.

## Report-only validation (where Intune exists)
- Sign-in logs → filter admin accounts → check device-state evaluation.
- Confirm at least one admin has a compliant device BEFORE enforcing.

## Rollback
Set `state` to `disabled`, re-run apply.