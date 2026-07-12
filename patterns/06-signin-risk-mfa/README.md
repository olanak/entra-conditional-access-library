# Pattern 06 — Medium Sign-in Risk: Require MFA

When Identity Protection rates a sign-in **medium risk**, require fresh MFA to remediate in-session.

## Why
Medium risk is suspicious but not conclusive. Blocking causes false-positive lockouts; MFA proves the user and clears the sign-in risk. High risk is blocked separately (CA04).

**ATT&CK:** T1078 (Valid Accounts)

## How
`sign_in_risk_levels = ["medium"]` → require `mfa`, plus 1-hour sign-in frequency so the MFA is fresh. Break-glass excluded.

## License
Entra ID **P2** (Identity Protection).

## The risk-tier trio
- **04:** high sign-in risk → block
- **06 (this):** medium sign-in risk → MFA
- **05:** high user risk → password change

## Files
`../../terraform/06-signin-risk-mfa.tf` · `test-scenarios.md`

## Deploy
```bash
terraform apply -target=azuread_conditional_access_policy.ca06_signin_risk_mfa
```
Report-only first.