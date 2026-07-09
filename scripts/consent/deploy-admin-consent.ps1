#Requires -Modules Microsoft.Graph.Authentication, Microsoft.Graph.Identity.SignIns
<#
.SYNOPSIS
  Pattern 11 - Require admin consent for OAuth apps.
  Disables user consent tenant-wide so only admins can grant app permissions.
  Mitigates illicit consent grant attacks (ATT&CK T1528).

.NOTES
  Not a Conditional Access policy - this is the tenant authorization policy.
  No azuread Terraform resource exists (provider issues #902 / #1183), so Graph PowerShell.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$Report   # show current setting only, make no changes
)

Connect-MgGraph -Scopes "Policy.ReadWrite.Authorization" -NoWelcome

$current = Get-MgPolicyAuthorizationPolicy
Write-Host "Current permissionGrantPoliciesAssigned:" -ForegroundColor Cyan
$current.DefaultUserRolePermissions.PermissionGrantPoliciesAssigned

if ($Report) { return }

# Empty array = user consent disabled = admin consent required for all apps
if ($PSCmdlet.ShouldProcess("tenant authorization policy", "disable user consent (require admin consent)")) {
    Update-MgPolicyAuthorizationPolicy -DefaultUserRolePermissions @{
        PermissionGrantPoliciesAssigned = @()
    }
    Write-Host "User consent disabled - admin consent now required for OAuth apps." -ForegroundColor Green
}