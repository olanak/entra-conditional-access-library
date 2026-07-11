# Pattern 12 — Secure Security-Info Registration: Test Scenarios

**Policy:** CA12 - Secure Security Info Registration (Trusted Locations Only)
**State:** report-only → enforce after review
**ATT&CK:** T1556.006, T1098.005
**License:** P1+

| # | Scenario | Expected (enforced) |
|---|----------|---------------------|
| 1 | User registers MFA from a trusted country | Allowed |
| 2 | User registers MFA from an untrusted country | Blocked |
| 3 | Normal sign-in (not registering security info) | Out of scope, unaffected |
| 4 | Break-glass account | Allowed (excluded) |

## Report-only validation
- Sign-in logs → filter user action = "Register security information" → confirm location evaluation.
- Confirm legitimate users onboard from trusted geography before enforcing.
- Consider a onboarding exception process for staff traveling during first registration.

## Rollback
Set `state` to `disabled`, re-run apply.