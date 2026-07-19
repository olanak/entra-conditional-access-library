# Decision Framework

How to choose and sequence the patterns in this library.

## Security Defaults vs Conditional Access

Before deploying any pattern, understand the baseline this library replaces.

**Security Defaults** are a free, on-by-default set of identity protections (MFA
registration, MFA for admins, risk-based MFA prompts, legacy-authentication blocking). They
are a single toggle with no configuration — a sensible floor for small organisations without
P1 licensing.

**Conditional Access** is the granular, policy-driven alternative used by enterprises.

The two are **mutually exclusive** — Entra will not let both be enabled. Using any
Conditional Access policy requires Security Defaults to be **disabled**, and Conditional
Access requires Entra ID **P1** or higher.

| | Security Defaults | Conditional Access |
|---|---|---|
| Cost | Free (all tiers) | P1 / P2 |
| Configuration | None (one switch) | Fully granular |
| Targeting | All users, no exceptions | Per user / group / app / role / risk |
| Break-glass exclusions | Not possible | Supported |
| Report-only testing | No | Yes |
| Legacy auth | Blocked (all-or-nothing) | Blocked, with scoping and exclusions |
| Risk-based conditions | No | Yes (P2) |

This library assumes Security Defaults are **off** and replaces their coarse protections with
the equivalent, refined patterns (01, 02, 03), plus capabilities Security Defaults do not
offer at all — risk tiers (04–06), device compliance (07), and the rest.

## Deployment order

Deploy in this order — each stage builds on the previous and is progressively higher-risk to
enforce. Everything ships report-only first (see [`DEPLOYMENT-GUIDE.md`](DEPLOYMENT-GUIDE.md)).

1. **Foundation (P1, do first):** 01 block legacy auth → 02 require MFA → 03 phishing-resistant MFA for admins.
2. **Risk-based (P2):** 04 high sign-in risk → 06 medium sign-in risk → 05 high user risk.
3. **Device and location (P1; 07 needs Intune):** 07 compliant device for admins → 08 location controls → 12 secure security-info registration.
4. **App and session (P1; 09 needs Intune):** 09 app protection policy → 10 sign-in frequency → 14 app-enforced restrictions → 11 admin consent for OAuth apps.
5. **Scope and governance:** 15 block guest access → 13 workload identity (needs Workload ID Premium) → 16 PIM JIT activation → 17 PIM access reviews.

## Decision tree

Work from the nature of the risk to the pattern that addresses it:

- **How they authenticate** → 01 (legacy auth), 02 (MFA), 03 (phishing-resistant MFA for admins).
- **The session looks suspicious** → 04 (block high risk), 06 (MFA on medium risk).
- **The account is likely compromised** → 05 (force password change).
- **The device** → 07 (require compliant/managed device).
- **Where they are** → 08 (location controls), 12 (restrict MFA registration to trusted locations).
- **The app or the data** → 09 (app protection), 10 (short session lifetime), 14 (app-enforced restrictions), 11 (admin-only OAuth consent).
- **Who the identity is** → 15 (guests), 13 (service principals / workload identities).
- **Standing privilege** → 16 (just-in-time activation), 17 (recurring access reviews).

## Rules of thumb

- Always deploy **report-only** first; enforce after roughly 7 days of clean logs.
- Never enforce a device or compliance policy (07, 09) without confirming at least one satisfying device exists.
- Break-glass accounts are excluded from **every** policy — no exceptions.
- Prefer remediation over blocking where the user can recover safely: high user risk forces a password change (05); medium sign-in risk steps up to MFA (06). Reserve hard blocks for high-confidence signals (04) and clear policy violations (01, 15).
- Match the tool to the control: Conditional Access in Terraform; tenant-authorization and PIM in Graph PowerShell (see [`docs/adr/0001-deployment-tooling.md`](docs/adr/0001-deployment-tooling.md)).

## Layering, not stacking

The patterns are designed to complement rather than duplicate each other. For example the
three risk patterns form a graduated response (04 high → block, 06 medium → MFA, 05 user →
password change), and admin protection is defence-in-depth across authentication strength
(03), device (07), and just-in-time privilege (16). Deploy the whole set for coverage, but
each pattern is independently valid.