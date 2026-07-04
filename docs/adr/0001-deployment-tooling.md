# ADR 0001 — Deployment Tooling

## Status
Accepted — 2026-06-30

## Context
The library deploys Entra ID Conditional Access + PIM as code. Options: Bicep,
Terraform, Microsoft Graph PowerShell.

## Decision
- **Conditional Access (patterns 01–15): Terraform** via `azuread_conditional_access_policy`.
  Stable, GA, supports risk-based (P2) conditions.
- **PIM (patterns 16–17): Microsoft Graph PowerShell** in `scripts/pim/`.
  Terraform's PIM coverage for Entra roles/access reviews is incomplete; parts
  still require the Graph Role Management Policy API.
- **Terraform is the single source of truth** for CA. Original policy.json and
  deploy.ps1 are archived, not maintained.

## Rejected
- **Bicep** — the Microsoft.Graph extension has no `conditionalAccessPolicies` type (BCP029).
- **All-PowerShell** — weaker IaC ergonomics (no plan/state) for the CA bulk.

## Consequences
- Two tools by design; split is documented and intentional.
- No definition drift (one source of truth per policy).
