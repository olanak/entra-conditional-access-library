# Entra Conditional Access Library

[![Terraform Validate](https://github.com/olanak/entra-conditional-access-library/actions/workflows/terraform-validate.yml/badge.svg)](https://github.com/olanak/entra-conditional-access-library/actions/workflows/terraform-validate.yml)
[![PowerShell Lint](https://github.com/olanak/entra-conditional-access-library/actions/workflows/powershell-lint.yml/badge.svg)](https://github.com/olanak/entra-conditional-access-library/actions/workflows/powershell-lint.yml)

Production-ready Microsoft Entra ID identity-security patterns as code — Conditional Access,
tenant authorization, and Privileged Identity Management — mapped to MITRE ATT&CK and
deployed via **Terraform** (`azuread`) and **Microsoft Graph PowerShell**.

> ⚠️ **Read [`docs/break-glass-accounts.md`](docs/break-glass-accounts.md) before deploying anything.**
> Every policy excludes two emergency Global Admin accounts to prevent tenant lockout.

## Overview

This library treats identity security as versioned, testable infrastructure rather than
manual portal configuration. Each pattern is a self-contained unit: the definition, the
attack it defends against (mapped to MITRE ATT&CK), test scenarios, and a rollback path.

Most patterns are Conditional Access policies deployed with Terraform. A few controls are
not Conditional Access policies at all — a tenant authorization setting and two PIM controls
— and are deployed with Microsoft Graph PowerShell. Routing each control to the correct tool
is a deliberate design decision, recorded in [`docs/adr/0001-deployment-tooling.md`](docs/adr/0001-deployment-tooling.md).

## Design principles

- **Report-only first.** Every Conditional Access pattern ships in `enabledForReportingButNotEnforced`; enforce only after reviewing logs.
- **Break-glass always excluded.** Two emergency accounts, created before any policy, excluded from every policy.
- **Attack-mapped.** Each pattern names the ATT&CK technique it defends against — see [`ATTACK-MAPPING.md`](ATTACK-MAPPING.md).
- **One source of truth.** Terraform HCL defines each CA policy; documentation lives beside it, never duplicated.
- **Right tool per control.** CA policies in Terraform; tenant-authorization and PIM controls in Graph PowerShell.
- **Detect, not just prevent.** A Microsoft Sentinel layer validates that policies behave as intended — see [`docs/monitoring.md`](docs/monitoring.md).

## Patterns

| # | Pattern | Defends against | ATT&CK | License | Deploy | Status |
|---|---------|-----------------|--------|---------|--------|--------|
| 01 | Block legacy authentication | Password spray | T1110 | P1 | Terraform | Live (report-only) |
| 02 | Require MFA for all users | Account compromise | T1078 | P1 | Terraform | Live (report-only) |
| 03 | Phishing-resistant MFA for admins | AiTM, MFA fatigue | T1621, T1566 | P1 | Terraform | Live (report-only) |
| 04 | Block high sign-in risk | Anonymous IP / Tor, malware IPs | T1090.003, T1078 | P2 | Terraform | Live (report-only) |
| 05 | High user risk → password change | Leaked credentials | T1078 | P2 | Terraform | Live (report-only) |
| 06 | Medium sign-in risk → MFA | Suspicious session | T1078 | P2 | Terraform | Live (report-only) |
| 07 | Require compliant device for admins | Endpoint compromise | T1078.004 | P1 + Intune | Terraform | Live (report-only) |
| 08 | Location-based controls | Geo-restricted threats | T1078 | P1 | Terraform | Live (report-only) |
| 09 | Require app protection policy | Data leak to unmanaged apps | T1528 | P1 + Intune | Terraform | Live (report-only) |
| 10 | Sign-in frequency (sensitive apps) | Token replay | T1550.001 | P1 | Terraform | Live (report-only) |
| 11 | Require admin consent for OAuth apps | Illicit consent grants | T1528 | P1 | Graph PowerShell | Live (enforced) |
| 12 | Secure security-info registration | MFA-registration hijack | T1556.006, T1098.005 | P1 | Terraform | Live (report-only) |
| 13 | Workload identity CA policy | Service principal abuse | T1078.004 | Workload ID Premium | Terraform | Code-complete (license-gated) |
| 14 | App-enforced restrictions | Data exfiltration | T1567 | P1 | Terraform | Live (report-only) |
| 15 | Block guest access to sensitive resources | Lateral movement | T1078.003 | P1 | Terraform | Live (report-only) |
| 16 | PIM — just-in-time admin activation | Standing privilege | T1078.004 | P2 | Graph PowerShell | Live (enforced) |
| 17 | PIM — access reviews for privileged roles | Privilege creep | T1098 | P2 | Graph PowerShell | Live (enforced) |

16 of 17 patterns are deployed to a live tenant; pattern 13 is code-complete but not
deployed, gated on a separate Workload Identities Premium license (documented, not faked).

## Repository structure

```
terraform/            # source of truth — Conditional Access patterns (one NN-*.tf each)
scripts/
  consent/            # pattern 11 — tenant authorization policy (Graph PowerShell)
  pim/                # patterns 16-17 — PIM (Graph PowerShell)
patterns/NN-*/        # README + test-scenarios per pattern (documentation)
docs/                 # break-glass, prerequisites, testing, monitoring, decision docs, adr/
archive/              # retired policy.json + deploy.ps1 (history)
.github/workflows/    # terraform validate/fmt + PowerShell lint (CI)
README.md
DECISION-FRAMEWORK.md
ATTACK-MAPPING.md
DEPLOYMENT-GUIDE.md
```

## Quick start

```bash
cd terraform
terraform init
terraform plan                    # dry run against your tenant
terraform apply                   # deploy all CA patterns (report-only)
```

Deploy a single Conditional Access pattern:

```bash
terraform apply -target=azuread_conditional_access_policy.ca01_block_legacy_auth
```

Non-Terraform patterns run from `scripts/` — see each pattern's README (11, 16, 17).

Set `tenant_id` and `break_glass_object_ids` in `terraform/terraform.tfvars` first.

## Documentation

- [`DEPLOYMENT-GUIDE.md`](DEPLOYMENT-GUIDE.md) — how to deploy safely (report-only → enforce).
- [`DECISION-FRAMEWORK.md`](DECISION-FRAMEWORK.md) — which pattern to apply when; Security Defaults vs Conditional Access.
- [`ATTACK-MAPPING.md`](ATTACK-MAPPING.md) — full MITRE ATT&CK coverage matrix.
- [`docs/prerequisites.md`](docs/prerequisites.md) — licensing, roles, tooling.
- [`docs/testing-strategy.md`](docs/testing-strategy.md) — the report-only → enforce lifecycle.
- [`docs/monitoring.md`](docs/monitoring.md) — Sentinel detections that validate the patterns.
- [`docs/break-glass-accounts.md`](docs/break-glass-accounts.md) — emergency access, read first.

## Licensing

Conditional Access requires Entra ID **P1**; the risk-based patterns (04–06) and PIM (16–17)
require **P2**. Patterns 07 and 09 additionally require Microsoft Intune; pattern 13 requires
Workload Identities Premium. See [`docs/prerequisites.md`](docs/prerequisites.md).
