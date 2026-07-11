# Pattern 12 — Secure Security-Info Registration

Restricts MFA method registration (registering or changing security info) to trusted
country locations only.

## Why
A password alone should never let someone enroll a new MFA method. If an attacker phishes
credentials and registers their own authenticator, they own the account — MFA becomes
theirs, not the victim's. Constraining registration to trusted locations blocks that
takeover path at its source.

**ATT&CK:** T1556.006 (Modify Authentication Process: MFA), T1098.005 (Account Manipulation: Device Registration)

## Replaces
This slot originally held Continuous Access Evaluation. CAE is enabled by default and its
policy control (strict enforcement) is not exposed by the `hashicorp/azuread` provider and
is preview-only, so it was replaced with this fully-supported, higher-value pattern. CAE
status verification is covered separately in monitoring.

## How
Condition = the `registersecurityinfo` user action, from all locations except the trusted
named location (pattern 08). Grant = block. Break-glass excluded.

## Dependency
Requires `azuread_named_location.allowed_countries` from pattern 08.

## License
Entra ID **P1+**.

## Files
`../../terraform/12-secure-security-info-registration.tf` · `test-scenarios.md`

## Deploy
```bash
terraform apply -target=azuread_conditional_access_policy.ca12_secure_security_info_registration
```
Report-only first. Verify your own admin registration path isn't blocked before enforcing.