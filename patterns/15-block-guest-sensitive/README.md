# Pattern 15 — Block Guest Access to Sensitive Resources

Blocks guest and external users from high-value resources (default: Azure management / ARM).

## Why
Guests are invited for specific collaboration, but external identities are a common lateral-
movement and privilege-escalation vector. They should never reach sensitive control planes
like Azure resource management. This enforces that boundary.

**ATT&CK:** T1078.003 (Valid Accounts: Local/External Accounts), lateral movement

## How
Scopes the `GuestsOrExternalUsers` user set against `sensitive_app_ids` (Azure management API
by default, shared with pattern 10) and blocks. Break-glass excluded.

## Tuning
Extend `var.sensitive_app_ids` to cover other guest-forbidden resources. To block guests
from *everything except* approved collaboration apps, invert the scope (include All apps,
exclude the collaboration set) — but test carefully to avoid breaking legitimate guest use.

## Note on scope
Conditional Access targets *applications*, not groups directly. "Sensitive groups" in the
original plan is realized here as sensitive *apps/resources*; group-level guest restriction
is better handled by access reviews (pattern 17) and entitlement management.

## License
Entra ID **P1+**.

## Files
`../../terraform/15-block-guest-sensitive.tf` · `test-scenarios.md`

## Deploy
```bash
terraform apply -target=azuread_conditional_access_policy.ca15_block_guest_sensitive
```
Report-only first.