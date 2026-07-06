# Pattern 08 — Location-Based Controls: Test Scenarios

**Policy:** CA08 - Block Sign-in from Untrusted Locations
**State:** report-only (high lockout risk — verify before enforcing)
**ATT&CK:** T1078
**License:** P1+

| # | Scenario | Expected (enforced) |
|---|----------|---------------------|
| 1 | Sign-in from an allowed country (e.g. TR) | Allowed |
| 2 | Sign-in from a non-allowed country | Blocked |
| 3 | Sign-in from an un-geolocatable IP | Blocked (unknown = untrusted) |
| 4 | Break-glass account | Allowed (excluded) |

## Report-only validation
- Sign-in logs → Location column → confirm your own sign-ins map to an allowed country.
- Insights and reporting → check no legitimate user would be blocked by geography.
- Test with a VPN exit in a non-allowed country → expect "would block".

## Rollback
Set `state` to `disabled`, re-run apply.