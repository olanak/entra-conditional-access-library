# Entra Conditional Access Library

Production-ready Microsoft Entra ID **Conditional Access** policy patterns, mapped to
MITRE ATT&CK identity techniques, deployed as code via **Terraform** (`azuread`), with
**Microsoft Graph PowerShell** for tenant-policy and PIM patterns that Terraform does not cover.

> ⚠️ **Read [`docs/break-glass-accounts.md`](docs/break-glass-accounts.md) before deploying anything.**
> Every policy excludes two emergency Global Admin accounts to prevent tenant lockout.

## Overview

A reference library that treats Conditional Access as versioned, testable infrastructure
rather than manual portal configuration. Each pattern is a complete unit: the policy
definition, the attack it defends against (mapped to MITRE ATT&CK), test scenarios, and a
rollback path.

Most patterns are Conditional Access policies deployed with Terraform. A few controls are
not Conditional Access policies at all (tenant authorization settings, PIM); those are
deployed with Microsoft Graph PowerShell and documented as such — routing each control to
the correct tool is a deliberate design choice.

## Design principles

- **Report-only first.** Every Conditional Access pattern ships in `enabledForReportingButNotEnforced`; enforce only after reviewing logs.
- **Break-glass always excluded.** Two emergency accounts, outside every policy.
- **Attack-mapped.** Each pattern names the ATT&CK technique it defends against — see [`ATTACK-MAPPING.md`](ATTACK-MAPPING.md).
- **One source of truth.** Terraform HCL defines each CA policy; docs live beside it, not duplicated.
- **Right tool per control.** CA policies in Terraform; tenant/authorization and PIM controls in Graph PowerShell.

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
| 12 | Continuous Access Evaluation | Token revocation latency | T1550.001 | P1 | Terraform | Planned |
| 13 | Workload identity CA policy | Service principal abuse | T1078.004 | Workload Identities P1 | Terraform | Planned |
| 14 | App-enforced restrictions | Data exfiltration | T1567 | P1 | Terraform | Planned |
| 15 | Block guest access to sensitive groups | Lateral movement | T1078.003 | P1 | Terraform | Planned |
| 16 | PIM — just-in-time admin activation | Standing privilege | T1078.004 | P2 | Graph PowerShell | Planned |
| 17 | PIM — access reviews for privileged roles | Privilege creep | T1098 | P2 | Graph PowerShell | Planned |

## Repository structure

```
terraform/            # source of truth — CA patterns (one NN-*.tf each)
scripts/
  consent/            # pattern 11 — tenant authorization policy (Graph PowerShell)
  pim/                # patterns 16-17 — PIM (Graph PowerShell)
patterns/NN-*/        # README + test-scenarios per pattern (docs)
docs/                 # break-glass, prerequisites, testing, monitoring, adr/
archive/              # retired policy.json + deploy.ps1 (history)
.github/workflows/    # terraform validate/fmt + policy lint
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

Non-Terraform patterns are run from `scripts/` — see each pattern's README (e.g. pattern 11).

Set `tenant_id` and `break_glass_object_ids` in `terraform/terraform.tfvars` first.

## Tooling

Terraform for Conditional Access; Microsoft Graph PowerShell for controls the `azuread`
provider does not expose (tenant authorization policy in pattern 11, PIM in 16–17).
Rationale is recorded in
[`docs/adr/0001-deployment-tooling.md`](docs/adr/0001-deployment-tooling.md) — Bicep was
evaluated and rejected because its Microsoft Graph extension has no
`conditionalAccessPolicies` resource type.

## Licensing

Conditional Access requires Entra ID **P1**; the risk-based patterns (04–06) require **P2**
(Identity Protection). Some patterns additionally require Microsoft Intune. See
[`docs/prerequisites.md`](docs/prerequisites.md).

## Status

Active development — 11 of 17 patterns deployed (10 Conditional Access in report-only, plus
the pattern 11 tenant authorization setting).

## License

MIT