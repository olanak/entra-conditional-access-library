#Requires -Modules Microsoft.Graph.Authentication
[CmdletBinding()]
param([string]$PolicyPath = "$PSScriptRoot/policy.json")

Connect-MgGraph -Scopes "Policy.ReadWrite.ConditionalAccess","Policy.Read.All" -NoWelcome

$name = (Get-Content $PolicyPath -Raw | ConvertFrom-Json).displayName
$existing = Get-MgIdentityConditionalAccessPolicy -Filter "displayName eq '$name'" -ErrorAction SilentlyContinue
if ($existing) { Write-Host "'$name' exists (Id: $($existing.Id)). Skipping." -ForegroundColor Yellow; return }

$new = New-MgIdentityConditionalAccessPolicy -BodyParameter (Get-Content $PolicyPath -Raw)
Write-Host "Created '$name' in state '$($new.State)' (Id: $($new.Id))" -ForegroundColor Green