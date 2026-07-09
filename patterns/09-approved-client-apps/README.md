# Pattern 09 — Require App Protection Policy

Requires that access to Office 365 from mobile devices happens only through client apps
that enforce a Microsoft **app protection policy** (Intune MAM) — e.g. Outlook mobile,
Teams — rather than arbitrary third-party apps.

## Why
App protection policies enforce data-loss controls (no copy/paste to personal apps,
encryption, selective wipe) and assess how an app *handles* corporate data after access is
granted. This stops data leaking into unmanaged apps and reduces token theft via rogue clients.

**ATT&CK:** T1528 (Steal Application Access Token)

## Current-control note (important)
This pattern uses **Require app protection policy** (`compliantApplication`), **not** the
older **Require approved client app** (`approvedApplication`) grant. The approved-client-app
control **retired on 30 June 2026** and is now read-only — it can no longer be created or
edited, and is not enforced. Microsoft's guidance is to use only the app-protection-policy
grant for new policies, which provides the same protection with additional data-handling benefits.

## How
Scoped to `Office365` on `mobileAppsAndDesktopClients` for iOS/Android; grant requires
`compliantApplication`. Break-glass excluded.

## ⚠️ Lab limitation
`compliantApplication` requires **Intune app protection (MAM)** policies to be configured
and a broker app (Microsoft Authenticator / Company Portal) on the device. A trial tenant
without Intune cannot satisfy or fully test this. Policy is deploy-correct and validated by
design; in an Intune-enabled tenant it enforces as written.

## Note
App-protection controls apply to supporting mobile/desktop apps, not browser sessions — hence
the platform + client-app scoping. Browser access is governed by other patterns.

## License
Entra ID **P1+**; requires Intune for app protection policies.

## Files
`../../terraform/09-approved-client-apps.tf` · `test-scenarios.md`

## Deploy
```bash
terraform apply -target=azuread_conditional_access_policy.ca09_approved_client_apps
```
Report-only first.