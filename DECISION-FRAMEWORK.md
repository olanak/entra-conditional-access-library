# Decision Framework — Which Pattern First?

A deployment order and "when to apply what" guide. _Skeleton — expanded at project completion._

## Deployment order (safest to advanced)

1. **Foundation (do first):** 01 block legacy auth → 02 require MFA → 03 phishing-resistant MFA for admins.
2. **Risk-based (requires P2):** 04 high sign-in risk → 06 medium sign-in risk → 05 high user risk.
3. **Device (requires Intune):** 07 compliant device for admins.
4. **App and session:** 09–12.
5. **Scope and governance:** 13–17.

## Rules of thumb

- Always deploy **report-only** first; enforce after ~7 days of clean logs.
- Never enforce a device/compliance policy without confirming at least one satisfying device exists.
- Break-glass accounts are excluded from **every** policy — no exceptions.

## Decision tree (to expand)

- Is the risk about *how they authenticate*? → 01, 02, 03
- About *the session looking suspicious*? → 04, 06
- About *the account being compromised*? → 05
- About *the device*? → 07
- About *the app or data*? → 09–14
- About *standing privilege*? → 16, 17

_TODO: full flowchart, per-industry baselines, exception-handling guidance._