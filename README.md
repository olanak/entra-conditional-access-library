# Entra Conditional Access Library

Production-ready Microsoft Entra ID **Conditional Access** policy patterns, mapped to
MITRE ATT&CK identity techniques, deployed as code via **Terraform** (`azuread`) with
**Microsoft Graph PowerShell** for the PIM patterns.

> ⚠️ **Read [`docs/break-glass-accounts.md`](docs/break-glass-accounts.md) before deploying anything.**
> Every policy excludes two emergency Global Admin accounts to prevent tenant lockout.

## Overview

A reference library that treats Conditional Access as versioned, testable infrastructure
rather than manual portal configuration. Each pattern is a complete unit: the policy
definition, the attack it defends against (mapped to MITRE ATT&CK), test scenarios, and a
rollback path.

## Design principles

- **Report-only first.** Every pattern ships in `enabledForReportingButNotEnforced`; enforce only after reviewing logs.
- **Break-glass always excluded.** Two emergency accounts, outside every policy.
- **Attack-mapped.** Each pattern names the ATT&CK technique it defends against — see [`ATTACK-MAPPING.md`](ATTACK-MAPPING.md).
- **One source of truth.** Terraform HCL defines each CA policy; docs live beside it, not duplicated.

## Patterns

| # | Pattern | Defends against | ATT&CK | License | Status |
|---|---------|-----------------|--------|---------|--------|
| 01 | Block legacy authentication | Password spray | T1110 | P1 | Live (report-only) |
| 02 | Require MFA for all users | Account compromise | T1078 | P1 | Live |
| 03 | Phishing-resistant MFA for admins | AiTM, MFA fatigue | T1621, T1566 | P1 | Live |
| 04 | Block high sign-in risk | Anonymous IP / Tor, malware IPs | T1090.003, T1078 | P2 | Live |
| 05 | High user risk → password change | Leaked credentials | T1078 | P2 | Live |
| 06 | Medium sign-in risk → MFA | Suspicious session | T1078 | P2 | Live |
| 07 | Require compliant device for admins | Endpoint compromise | T1078.004 | P1 + Intune | Live |
| 08 | Location-based controls | Geo-restricted threats | T1078 | P1 | Planned |
| 09 | Require approved client apps | Token theft via rogue apps | T1528 | P1 | Planned |
| 10 | Sign-in frequency (sensitive apps) | Token replay | T1550.001 | P1 | Planned |
| 11 | Require admin consent for OAuth apps | Illicit consent grants | T1528 | P1 | Planned |
| 12 | Continuous Access Evaluation | Token revocation latency | T1550.001 | P1 | Planned |
| 13 | Workload identity CA policy | Service principal abuse | T1078.004 | Workload Identities P1 | Planned |
| 14 | App-enforced restrictions | Data exfiltration | T1567 | P1 | Planned |
| 15 | Block guest access to sensitive groups | Lateral movement | T1078.003 | P1 | Planned |
| 16 | PIM — just-in-time admin activation | Standing privilege | T1078.004 | P2 | Planned (PowerShell) |
| 17 | PIM — access reviews for privileged roles | Privilege creep | T1098 | P2 | Planned (PowerShell) |

## Repository structure

```
terraform/            # source of truth — CA patterns 01-15 (one NN-*.tf each)
scripts/pim/          # PIM patterns 16-17 (Graph PowerShell)
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
terraform apply                   # deploy all (report-only)
```

Deploy a single pattern:

```bash
terraform apply -target=azuread_conditional_access_policy.ca01_block_legacy_auth
```

Set `tenant_id` and `break_glass_object_ids` in `terraform/terraform.tfvars` first.

## Tooling

Terraform for Conditional Access, PowerShell/Graph for PIM. Rationale is recorded in
[`docs/adr/0001-deployment-tooling.md`](docs/adr/0001-deployment-tooling.md) — Bicep was
evaluated and rejected because its Microsoft Graph extension has no
`conditionalAccessPolicies` resource type.

## Licensing

Conditional Access requires Entra ID **P1**; the risk-based patterns (04–06) require **P2**
(Identity Protection). See [`docs/prerequisites.md`](docs/prerequisites.md).

## Status

Active development — 7 of 17 patterns deployed in report-only mode.

## License

MIT