# Pattern 04 — Block High Sign-in Risk

Blocks any sign-in that Identity Protection rates **high risk** — including anonymous IP/Tor, malware-linked IPs, and impossible-travel signals.

## Why
A high-risk sign-in is a live compromise signal. Blocking outright (vs MFA) is correct at the high tier; medium risk is remediated in pattern 06.

**ATT&CK:** T1090.003 (anonymizing proxies), T1078 (Valid Accounts)

## How
`sign_in_risk_levels = ["high"]` + `block`. All users; break-glass excluded.

## License
Entra ID **P2** (Identity Protection). Risk detections are on by default in P2.

## Relationship to pattern 06
- **04 (this):** high risk → hard block.
- **06:** medium risk → require MFA + password change (remediate, not block).

## Files
`../../terraform/04-block-high-signin-risk.tf` (definition) · `test-scenarios.md`

## Deploy
```bash
terraform apply -target=azuread_conditional_access_policy.ca04_block_high_signin_risk
```
Report-only first.