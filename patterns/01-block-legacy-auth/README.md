# Pattern 01 — Block Legacy Authentication

Blocks legacy auth protocols (IMAP, POP, SMTP AUTH, older Office/ActiveSync) that can't enforce MFA.

## Why
Legacy auth bypasses MFA — the #1 password-spray vector. ~99% of password-spray sign-ins use it.

**ATT&CK:** T1110 (Brute Force / Password Spray)

## How it works
`clientAppTypes: [exchangeActiveSync, other]` + `block`. All users in scope; both break-glass accounts excluded.

## Files
| File | Purpose |
|------|---------|
| `policy.json` | CA policy definition (report-only) |
| `deploy.ps1` | Idempotent Graph deploy |
| `test-scenarios.md` | Test matrix + rollback |

## Deploy
```powershell
./deploy.ps1
```
Ships report-only. Enforce after 7 clean days (see test-scenarios.md).

## License
Entra ID P1+.