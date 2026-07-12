# Pattern 16 — PIM JIT Activation: Test Scenarios

**Control:** PIM role activation policy (Graph)
**ATT&CK:** T1078.004
**License:** P2

| # | Scenario | Expected |
|---|----------|----------|
| 1 | Eligible admin activates the role | Prompted for MFA + justification, granted for <= max duration |
| 2 | Activation without MFA | Blocked |
| 3 | Activated role after max duration elapses | Auto-deactivated |
| 4 | Permanent (active) assignment | Unaffected — convert separately to eligible |

## Validation
- `./configure-pim-role.ps1 -Report` → confirm Enablement rule shows MFA + Justification, Expiration shows the max duration.
- Portal: Entra → Identity Governance → PIM → Microsoft Entra roles → (role) → Role settings.
- Test-activate as an eligible user (Entra → PIM → My roles).

## Rollback
Re-run `Update-MgPolicyRoleManagementPolicyRule` with the prior values, or reset the role
settings to default in the PIM portal.