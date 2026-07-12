#Requires -Modules Microsoft.Graph.Authentication, Microsoft.Graph.Identity.Governance
<#
.SYNOPSIS
  Pattern 16 - PIM just-in-time activation.
  Hardens the activation policy for an Entra role: require MFA + justification on activation,
  and cap activation duration. Turns standing admin access into on-demand, time-bound access.
.NOTES
  Requires Entra ID P2. Graph updates EXISTING PIM policy rules by ID (no create).
#>
[CmdletBinding()]
param(
    # Global Administrator by default
    [string]$RoleTemplateId    = "62e90394-69f5-4237-9190-012177145e10",
    [string]$MaxActivationHours = "PT4H",   # ISO 8601 duration
    [switch]$Report
)

Connect-MgGraph -Scopes "RoleManagementPolicy.ReadWrite.Directory","RoleManagement.ReadWrite.Directory" -NoWelcome

# 1. Find the PIM policy governing this role at directory scope
$assignment = Get-MgPolicyRoleManagementPolicyAssignment `
    -Filter "scopeId eq '/' and scopeType eq 'DirectoryRole' and roleDefinitionId eq '$RoleTemplateId'"
$policyId = $assignment.PolicyId
Write-Host "PIM policy for role $RoleTemplateId : $policyId" -ForegroundColor Cyan

# 2. Inspect current rules
$rules = Get-MgPolicyRoleManagementPolicyRule -UnifiedRoleManagementPolicyId $policyId
if ($Report) {
    $rules | Select-Object Id, AdditionalProperties | Format-List
    return
}

# 3a. Activation max duration (Expiration_EndUser_Assignment)
Update-MgPolicyRoleManagementPolicyRule `
    -UnifiedRoleManagementPolicyId $policyId `
    -UnifiedRoleManagementPolicyRuleId "Expiration_EndUser_Assignment" `
    -BodyParameter @{
        "@odata.type"        = "#microsoft.graph.unifiedRoleManagementPolicyExpirationRule"
        id                   = "Expiration_EndUser_Assignment"
        isExpirationRequired = $true
        maximumDuration      = $MaxActivationHours
        target               = @{ "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyRuleTarget"; caller = "EndUser"; operations = @("all"); level = "Assignment" }
    }

# 3b. Require MFA + justification on activation (Enablement_EndUser_Assignment)
Update-MgPolicyRoleManagementPolicyRule `
    -UnifiedRoleManagementPolicyId $policyId `
    -UnifiedRoleManagementPolicyRuleId "Enablement_EndUser_Assignment" `
    -BodyParameter @{
        "@odata.type"  = "#microsoft.graph.unifiedRoleManagementPolicyEnablementRule"
        id             = "Enablement_EndUser_Assignment"
        enabledRules   = @("MultiFactorAuthentication","Justification")
        target         = @{ "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyRuleTarget"; caller = "EndUser"; operations = @("all"); level = "Assignment" }
    }

Write-Host "PIM activation hardened: MFA + justification required, max $MaxActivationHours." -ForegroundColor Green