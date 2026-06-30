# Break-Glass Accounts

Two cloud-only Global Administrator accounts exist as emergency access and are
**excluded from every Conditional Access policy** in this library.

| Account | UPN | Role | Excluded from CA |
|---|---|---|---|
| Break Glass 1 | breakglass1@<tenant>.onmicrosoft.com | Global Administrator | Yes (all policies) |
| Break Glass 2 | breakglass2@<tenant>.onmicrosoft.com | Global Administrator | Yes (all policies) |

## Rules
- Passwords are long, random, stored in a password manager only.
- These accounts are never used for day-to-day administration.
- Every CA policy MUST list both under `excludeUsers`.
- Primary admin is a separate identity, so break-glass is an independent recovery path.

## Why
Conditional Access can lock out every admin (e.g. a policy that blocks all access
or requires a control no admin can satisfy). Excluded break-glass accounts are the
recovery path. This is the #1 operational safeguard in identity security.
