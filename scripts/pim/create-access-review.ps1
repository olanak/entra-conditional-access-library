#Requires -Modules Microsoft.Graph.Authentication, Microsoft.Graph.Identity.Governance
<#
.SYNOPSIS
  Pattern 17 - PIM access review for a privileged Entra role.
  Recurring re-attestation of who holds the role; unreviewed access auto-removed.
.NOTES
  Requires Entra ID P2. Connect first: Connect-MgGraph -Scopes "AccessReview.ReadWrite.All","User.Read.All"
#>
[CmdletBinding()]
param(
    [string]$RoleTemplateId = "62e90394-69f5-4237-9190-012177145e10", # Global Administrator
    [string]$RoleName       = "Global Administrator",
    [int]$DurationDays      = 7,
    [string]$ReviewerUpn    = "breakglass1@olana5000gmail.onmicrosoft.com" # concrete reviewer
)

# Resolve reviewer object ID (reviewers need a real /users/<id>)
$reviewer = Get-MgUser -UserId $ReviewerUpn
if (-not $reviewer) { throw "Reviewer $ReviewerUpn not found." }

$body = @{
    displayName          = "Access Review - $RoleName (PIM)"
    descriptionForAdmins = "Recurring re-attestation of $RoleName assignments (pattern 17)."
    scope = @{
        "@odata.type" = "#microsoft.graph.principalResourceMembershipsScope"
        principalScopes = @(
            @{ "@odata.type" = "#microsoft.graph.accessReviewQueryScope"; query = "/users";  queryType = "MicrosoftGraph" }
            @{ "@odata.type" = "#microsoft.graph.accessReviewQueryScope"; query = "/groups"; queryType = "MicrosoftGraph" }
        )
        resourceScopes = @(
            @{ "@odata.type" = "#microsoft.graph.accessReviewQueryScope"; query = "/roleManagement/directory/roleDefinitions/$RoleTemplateId"; queryType = "MicrosoftGraph" }
        )
    }
    reviewers = @(
        @{ query = "/users/$($reviewer.Id)"; queryType = "MicrosoftGraph" }
    )
    settings = @{
        mailNotificationsEnabled        = $true
        reminderNotificationsEnabled    = $true
        justificationRequiredOnApproval = $true
        defaultDecisionEnabled          = $true
        defaultDecision                 = "Deny"
        instanceDurationInDays          = $DurationDays
        autoApplyDecisionsEnabled       = $true
        recommendationsEnabled          = $true
        recurrence = @{
            pattern = @{ type = "absoluteMonthly"; interval = 1 }
            range   = @{ type = "noEnd"; startDate = (Get-Date -Format "yyyy-MM-dd") }
        }
    }
}

$review = New-MgIdentityGovernanceAccessReviewDefinition -BodyParameter $body
Write-Host "Access review created: $($review.DisplayName) (Id: $($review.Id))" -ForegroundColor Green
Write-Host "Monthly | $DurationDays-day instances | reviewer: $ReviewerUpn | unreviewed => Deny + auto-apply." -ForegroundColor Cyan