# Pattern 13 — Workload Identity CA: Test Scenarios

**Policy:** CA13 - Block Service Principal from Untrusted Locations
**State:** report-only when deployed (currently NOT deployed — license-gated)
**ATT&CK:** T1078.004
**License:** P1+ and Workload Identities Premium

| # | Scenario | Expected (with license, enforced) |
|---|----------|-----------------------------------|
| 1 | Protected SP requests token from trusted country | Allowed |
| 2 | Protected SP requests token from untrusted location | Blocked |
| 3 | A non-protected SP | Out of scope |
| 4 | Managed identity / multitenant app | Not eligible (excluded by design) |

## Validation status
Code-complete and `terraform validate`-passing. Not applied — requires Workload Identities
Premium. Under that license: deploy report-only, then Sign-in logs → service-principal
sign-ins → confirm location evaluation before enforcing.

## Rollback
Set `state` to `disabled`, re-run apply.