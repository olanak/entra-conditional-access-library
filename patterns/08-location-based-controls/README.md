# Pattern 08 — Location-Based Controls

Blocks sign-ins originating outside a defined set of trusted countries.

## Why
If your organisation only operates in specific countries, sign-ins from elsewhere are
suspicious by default. Geo-fencing shrinks the attack surface for password spray and
account takeover from foreign infrastructure.

**ATT&CK:** T1078 (Valid Accounts)

## How
A **named location** lists allowed countries. The policy targets *All locations except* that
list (i.e. all untrusted locations) and blocks. Break-glass excluded.

## ⚠️ Lockout risk
This is the highest-lockout-risk pattern. If your own country is missing from
`allowed_countries`, you block yourself. Keep it report-only until verified, and confirm
your admin's country is included. Break-glass accounts remain exempt.

## Tuning
Edit `local.allowed_countries` in `terraform/locals.tf`. Consider `include_unknown_countries_and_regions`
carefully — leaving it `false` means IPs Entra can't geolocate are treated as untrusted (blocked).

## License
Entra ID **P1+**.

## Files
`../../terraform/08-location-based-controls.tf` · `test-scenarios.md`

## Deploy
```bash
terraform apply -target=azuread_named_location.allowed_countries -target=azuread_conditional_access_policy.ca08_block_untrusted_locations
```
Report-only first.