# Monitoring

Detection and alerting layer for the Conditional Access library. Policies **prevent**;
monitoring **detects** what gets attempted and confirms the policies behave as intended.

## Architecture

- **Log source:** Microsoft Entra ID sign-in and audit logs, exported via Diagnostic
  Settings to a Log Analytics workspace (`law-entra-ca`).
- **SIEM:** Microsoft Sentinel, connected to that workspace (onboarded via the Defender
  portal, July 2026 onward).
- **Categories exported:** `SignInLogs`, `AuditLogs`, `NonInteractiveUserSignInLogs`,
  `RiskyUsers`, `UserRiskEvents`.

## Setup

1. Create a Log Analytics workspace (`law-entra-ca`).
2. Entra admin center → Monitoring & health → Diagnostic settings → send the five
   categories above to the workspace.
3. Enable Microsoft Sentinel on the workspace, then connect it in the Defender portal
   (Settings → Microsoft Sentinel → Connect and set as primary).
4. Develop and run KQL in the workspace's **Logs** editor (`portal.azure.com` →
   `law-entra-ca` → Logs). The Log Analytics tables (`SigninLogs`, `AuditLogs`, ...) are the
   query surface — not the Defender "Advanced hunting" tables.

## Detections

Each query maps to the pattern it validates. Time windows are tunable. In a healthy tenant
several of these return zero rows — that is the correct "nothing bad happened" state, not a
broken query.

### D1 — Legacy authentication attempts (validates pattern 01)

```kql
SigninLogs
| where TimeGenerated > ago(7d)
| where ClientAppUsed in ("Other clients", "IMAP4", "POP3", "SMTP", "Exchange ActiveSync", "Authenticated SMTP", "MAPI Over HTTP")
| summarize Attempts=count(), Users=dcount(UserPrincipalName) by ClientAppUsed, ResultType
| order by Attempts desc
```
Legacy auth is blocked by CA01; this surfaces anything still attempting it. Status: query
validated against schema; clean (no legacy attempts) in the lab tenant.

### D2 — Risky sign-ins (validates patterns 04 and 06) — CONFIRMED FIRING

```kql
SigninLogs
| where TimeGenerated > ago(7d)
| where RiskLevelDuringSignIn in ("high", "medium") or RiskState == "atRisk"
| project TimeGenerated, UserPrincipalName, IPAddress, Location, RiskLevelDuringSignIn, RiskState, ConditionalAccessStatus, AppDisplayName
| order by TimeGenerated desc
```
Validated with a live Tor sign-in: Identity Protection scored the session **medium** risk
from a Netherlands Tor exit. `ConditionalAccessStatus` returned `notApplied` because the
risk patterns are in report-only — the risk is scored but not enforced. Setting CA06 to
`enabled` changes this to `success` (MFA required). This is the end-to-end proof that the P2
risk detections and the risk-based patterns share the same signal.

### D3 — Conditional Access policy tampering (audit) — CONFIRMED FIRING

```kql
AuditLogs
| where TimeGenerated > ago(30d)
| where OperationName has "conditional access policy"
| project TimeGenerated, OperationName, InitiatedBy=tostring(InitiatedBy.user.userPrincipalName), Result
| order by TimeGenerated desc
```
"Watch the watchers" — any create/update/delete of a CA policy is captured and attributed.
Validated: two `Update conditional access policy` events on CA01 were recorded against the
initiating admin. Alert if the initiator is unexpected or the change weakens enforcement.

### D4 — Unusual OAuth consent (validates pattern 11)

```kql
AuditLogs
| where TimeGenerated > ago(30d)
| where OperationName has "Consent to application"
| project TimeGenerated, InitiatedBy=tostring(InitiatedBy.user.userPrincipalName), AppName=tostring(TargetResources[0].displayName), Result
| order by TimeGenerated desc
```
After pattern 11 (admin consent required), user consents should be near zero; a spike
signals attempted illicit consent. Status: query validated against schema; clean in the lab
(user consent disabled).

## Turning a query into an alert

In Sentinel (Defender portal) → Configuration → Analytics → Scheduled query rule: paste a
detection, set the cadence and threshold, and map it to the MITRE tactic/technique already
documented for that pattern. D2 (risky sign-in) and D3 (policy tampering) are the highest-
value rules to schedule first.

## Report-only caveat

While the Conditional Access patterns are in report-only, enforcement-dependent fields
(`ConditionalAccessStatus`) read `notApplied` even when risk is scored. This is expected and
is itself useful monitoring data during the report-only review window — it shows which
sign-ins *would* have been actioned before you enforce.

## Cost

Ingestion is billed per GB against the Log Analytics workspace. A lab tenant generates a
small fraction of the 1 GB/day cap. Review usage under the workspace's Usage and estimated
costs.