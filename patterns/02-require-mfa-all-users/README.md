# Pattern 02 — Require MFA for All Users

Requires MFA for every user, all apps, all client types.

## Why
MFA stops the vast majority of account-takeover from stolen/sprayed passwords.

**ATT&CK:** T1078 (Valid Accounts)

## How
`includeUsers: All` + `builtInControls: [mfa]`; both break-glass accounts excluded.

## Files
`policy.json` · `deploy.ps1` · `test-scenarios.md`

## Deploy
```powershell
./deploy.ps1
```
Report-only first. Confirm all users can register MFA, then enforce.

## License
Entra ID P1+.