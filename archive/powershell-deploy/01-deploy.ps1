#Requires -Modules Microsoft.Graph.Authentication
[CmdletBinding()]
param(
    [string]$PolicyPath = "$PSScriptRoot/policy.json"
)

Connect-MgGraph -Scopes "Policy.ReadWrite.ConditionalAccess","Policy.Read.All" -NoWelcome

$body = Get-Content $PolicyPath -Raw | ConvertFrom-Json
$name = $body.displayName

# Skip if a policy with this name already exists (idempotent)
$existing = Get-MgIdentityConditionalAccessPolicy -Filter "displayName eq '$name'" -ErrorAction SilentlyContinue
if ($existing) {
    Write-Host "Policy '$name' already exists (Id: $($existing.Id)). Skipping." -ForegroundColor Yellow
    return
}

$new = New-MgIdentityConditionalAccessPolicy -BodyParameter (Get-Content $PolicyPath -Raw)
Write-Host "Created '$name' in state '$($new.State)' (Id: $($new.Id))" -ForegroundColor Green