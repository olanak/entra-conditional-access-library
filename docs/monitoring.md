# Monitoring

Detection and alerting layer for the Conditional Access library. This complements the
policies: policies **prevent**, monitoring **detects** what gets attempted and whether the
policies behave as intended in production.

> **Status: planned.** This document is populated during the monitoring phase, once the
> Conditional Access patterns are deployed. KQL queries below are added only after being
> run against a live tenant.

## Planned scope

- **Log sources:** Entra sign-in logs and audit logs, exported to a Log Analytics
  workspace and surfaced in Microsoft Sentinel.
- **Detections (KQL):**
  - Legacy-authentication attempts (validates pattern 01).
  - Sign-ins from anonymous IP / Tor and high-risk sign-ins (validates 04, 06).
  - High user-risk events and password-change remediations (validates 05).
  - Mass or unusual OAuth consent grants (validates 11).
  - Conditional Access policy changes (audit-log monitoring for tampering).
- **Report-only signal:** dashboards summarising would-be blocks during the review window,
  to support the enforce/no-enforce decision described in
  [testing-strategy.md](testing-strategy.md).

## Cost note

Sentinel bills through an underlying Log Analytics workspace (per-GB ingestion +
retention). Unlike the Conditional Access policies, this is not free. Keep the workspace
small during evaluation and monitor consumption against available Azure credit.

## Native alternative (no Sentinel)

Some coverage is available without Sentinel:

- **Entra → Monitoring → Sign-in logs** with the Conditional Access / Report-only tabs.
- **Identity Protection → Risky sign-ins / Risky users** reports (P2).
- Built-in **Insights and reporting** workbook per policy.

These are used for report-only review today; Sentinel adds custom KQL, correlation, and
alerting on top.