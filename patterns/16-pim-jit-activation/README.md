# Pattern 16 — PIM Just-in-Time Admin Activation

Replaces standing (permanent) admin rights with **eligible** assignments that must be
activated on demand — requiring MFA and a justification, and expiring after a set time.

## Why
Permanent admin roles are always-on attack surface: if the account is compromised, the
privilege is immediately available. Just-in-time activation means the role is dormant until
explicitly activated with a second factor and a reason, and auto-expires — shrinking the
window of usable privilege from "always" to "a few hours, when needed."

**ATT&CK:** T1078.004 (Valid Accounts: Cloud Accounts), standing-privilege reduction

## Why PowerShell (not Terraform)
PIM policy configuration is not modelled by the `azuread` provider. It is done via the Graph
`roleManagementPolicy` rules API — the same routing decision as pattern 11.

## How
Finds the role's PIM policy at directory scope, then updates two existing rules:
- **Expiration_EndUser_Assignment** → activation capped (default 4h).
- **Enablement_EndUser_Assignment** → require MFA + justification.

## License
Entra ID **P2** (PIM).

## Files
`../../scripts/pim/configure-pim-role.ps1` · `test-scenarios.md`

## Deploy
```powershell
./scripts/pim/configure-pim-role.ps1 -Report    # inspect current rules
./scripts/pim/configure-pim-role.ps1            # apply to Global Admin (default)
# other role / duration:
./scripts/pim/configure-pim-role.ps1 -RoleTemplateId <id> -MaxActivationHours "PT2H"
```
No report-only mode for PIM policy — use `-Report` to inspect first.