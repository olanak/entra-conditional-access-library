# Pattern 10 — Sign-in Frequency for Sensitive Apps

Forces re-authentication every 4 hours when accessing high-value applications (default:
Azure management / ARM), overriding the default token lifetime of up to ~90 days.

## Why
Access tokens are valid long after issuance. If one is stolen (token theft/replay), a short
sign-in frequency limits the window an attacker can use it against sensitive apps.

**ATT&CK:** T1550.001 (Application Access Token)

## How
Scoped to `sensitive_app_ids` (default: Windows Azure Service Management API). Session
control sets `sign_in_frequency = 4 hours`, requiring fresh primary+secondary auth. Break-glass excluded.

## Tuning
Edit `var.sensitive_app_ids` in `terraform.tfvars` (or the default in `variables.tf`) to add
apps like Exchange, SharePoint, or specific line-of-business apps. Shorten the interval for
more sensitive apps.

## License
Entra ID **P1+**.

## Files
`../../terraform/10-signin-frequency-sensitive-apps.tf` · `test-scenarios.md`

## Deploy
```bash
terraform apply -target=azuread_conditional_access_policy.ca10_signin_frequency_sensitive
```
Report-only first.