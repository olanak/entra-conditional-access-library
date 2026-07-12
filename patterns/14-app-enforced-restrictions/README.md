# Pattern 14 — App-Enforced Restrictions

Passes device state (managed vs unmanaged) to Exchange Online and SharePoint Online so those
apps apply limited-access experiences — e.g. browser-only, no download / print / sync from
unmanaged devices.

## Why
Even after a user authenticates, corporate data can leave via download or sync onto a
personal device. App-enforced restrictions let SPO/EXO serve a reduced experience to
unmanaged sessions, keeping data in the browser rather than on the endpoint.

**ATT&CK:** T1567 (Exfiltration Over Web Service)

## How
Session control `application_enforced_restrictions_enabled = true`, scoped to browser
sessions against the Exchange Online and SharePoint Online app IDs (the only apps that honor
it). No grant control — the app enforces based on the signal. Break-glass excluded.

## ⚠️ Configuration dependency
The CA policy only *signals* the app. The actual limited-access behavior must also be
enabled in **SharePoint/OneDrive admin** ("unmanaged devices" → limited, web-only) and
**Exchange** (OWA mailbox policy). Without that app-side config, this policy is a no-op.
Deploy-correct here; full effect requires the SPO/EXO configuration.

## License
Entra ID **P1+**.

## Files
`../../terraform/14-app-enforced-restrictions.tf` · `test-scenarios.md`

## Deploy
```bash
terraform apply -target=azuread_conditional_access_policy.ca14_app_enforced_restrictions
```
Report-only first.