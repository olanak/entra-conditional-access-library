# Pattern 05 — High User Risk: Require Password Change

When Identity Protection flags a user as **high risk** (e.g. leaked credentials found), force secure self-remediation: MFA + password change.

## Why
High user risk = the account is likely compromised. Blocking traps the user; remediation lets them recover securely and clears the risk state.

**ATT&CK:** T1078 (Valid Accounts)

## How
`user_risk_levels = ["high"]` → grant requires **MFA AND passwordChange** (Microsoft mandates MFA alongside password change). Break-glass excluded.

## License
Entra ID **P2** (Identity Protection).

## Relationship
- **05 (this):** compromised *account* (user risk) → password change.
- **04:** compromised *session* (sign-in risk high) → block.
- **06:** medium sign-in risk → MFA.

## Files
`../../terraform/05-user-risk-remediation.tf` · `test-scenarios.md`

## Deploy
```bash
terraform apply -target=azuread_conditional_access_policy.ca05_user_risk_remediation
```
Report-only first.