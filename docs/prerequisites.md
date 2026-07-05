# Prerequisites

What you need before deploying any pattern in this library.

## Licensing

Conditional Access is not available on Entra ID Free. Each pattern lists its requirement;
the summary:

| Requirement | Patterns | Notes |
|-------------|----------|-------|
| **Entra ID P1** | 01, 02, 03, 08–15 | Core Conditional Access, MFA conditions, named locations, auth strength |
| **Entra ID P2** | 04, 05, 06 | Identity Protection (sign-in risk, user risk) |
| **Entra ID P2** | 16, 17 | Privileged Identity Management (PIM) |
| **Microsoft Intune** | 07 | Device compliance evaluation (or hybrid Entra join) |
| **Workload Identities P1** | 13 | Conditional Access for service principals |

A 30-day Entra ID P2 trial (up to 100 licenses) covers every P1 and P2 feature for
evaluation. P2 is a strict superset of P1.

## Directory roles

The account running Terraform needs one of:

- **Conditional Access Administrator** (least privilege for CA patterns), or
- **Security Administrator**, or
- **Global Administrator**.

PIM patterns (16, 17) additionally require **Privileged Role Administrator**.

## Break-glass accounts (mandatory)

Two cloud-only Global Administrator accounts must exist and be excluded from every policy
**before** any policy is deployed. See [break-glass-accounts.md](break-glass-accounts.md).

## Microsoft Graph permissions

When using PowerShell/Graph (PIM patterns, verification), connect with:

```
Policy.Read.All
Policy.ReadWrite.ConditionalAccess
RoleManagement.ReadWrite.Directory   # PIM only
```

## Tooling

| Tool | Version | Purpose |
|------|---------|---------|
| Terraform | >= 1.5 | CA patterns 01–15 |
| `hashicorp/azuread` provider | ~> 3.0 | Conditional Access resources |
| Azure CLI | current | Authentication (`az login --tenant <id>`) |
| PowerShell 7 + Microsoft.Graph | current | PIM patterns, verification |

## Authentication

Terraform's `azuread` provider authenticates through the Azure CLI session:

```bash
az login --tenant <your-tenant-id>
```

Confirm the target tenant before `terraform apply` — the provider deploys to whatever
tenant the CLI is signed into.

## Configuration

Populate `terraform/terraform.tfvars` before the first apply:

```hcl
tenant_id              = "<your-tenant-id>"
break_glass_object_ids = ["<breakglass1-object-id>", "<breakglass2-object-id>"]
```

This file is gitignored — it holds tenant-specific IDs and must not be committed.