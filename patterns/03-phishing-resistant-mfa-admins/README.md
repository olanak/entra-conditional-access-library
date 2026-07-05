# Pattern 03 — Phishing-Resistant MFA for Admins

Forces privileged roles to authenticate with phishing-resistant MFA (FIDO2, Windows Hello for Business, certificate-based).

## Why
Admins are the top target. SMS/app-push MFA is defeatable by adversary-in-the-middle (AiTM) proxies; phishing-resistant methods are not.

**ATT&CK:** T1621 (MFA Request Generation / fatigue), T1566 (Phishing)

## How
Scoped to admin role template IDs (Global, Privileged Role, Security, SharePoint, Exchange). Grant control = built-in **Phishing-resistant MFA** authentication strength. Break-glass excluded.

## License
Entra ID **P1+** (authentication strength is P1).

## Files
`../../terraform/03-phishing-resistant-mfa-admins.tf` (definition) · `test-scenarios.md`

## Deploy
```bash
terraform apply -target=azuread_conditional_access_policy.ca03_phishing_resistant_admins
```
Report-only first. **Ensure every admin has a phishing-resistant method registered before enforcing** — otherwise admins lock out (break-glass still safe).