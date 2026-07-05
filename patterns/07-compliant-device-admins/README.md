# Pattern 07 — Require Compliant Device for Admins

Admins may only sign in from a managed device: Intune-compliant **or** hybrid Entra-joined.

## Why
Even phishing-resistant MFA can't stop a compromised/unmanaged endpoint. Binding admin access to a known-good device closes that gap — defense in depth over CA03.

**ATT&CK:** T1078.004 (Cloud Accounts), endpoint compromise

## How
Scoped to admin roles; grant requires `compliantDevice` OR `domainJoinedDevice`. Break-glass excluded.

## License
Entra ID **P1+**. Device compliance requires **Intune** (or hybrid join) to evaluate.

## ⚠️ Lab limitation
This trial tenant has no Intune/MDM, so `compliantDevice` cannot be satisfied by a real device here. The policy is deploy-correct but validated by **design review**, not live enrollment. In an Intune-enabled tenant it works as written.

## Files
`../../terraform/07-compliant-device-admins.tf` · `test-scenarios.md`

## Deploy
```bash
terraform apply -target=azuread_conditional_access_policy.ca07_compliant_device_admins
```
Report-only. **Do not enforce without Intune** or you lock out all admins (break-glass still safe).