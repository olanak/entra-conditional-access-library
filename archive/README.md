# Archive

Superseded artifacts, kept for history and reference.

- `policy-json/` — original raw Graph API policy definitions (patterns 01–03).
  Replaced by Terraform (`terraform/*.tf`) as the single source of truth.
- `powershell-deploy/` — original Graph PowerShell deploy scripts.
  Replaced by Terraform for CA patterns; PowerShell retained only for PIM (see `scripts/pim/`).

Evolution: raw JSON + PowerShell → Terraform (`azuread`) for CA, PowerShell for PIM.
