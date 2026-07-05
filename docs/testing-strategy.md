# Testing Strategy

Every pattern moves through the same lifecycle before it is enforced. The goal is to prove
a policy behaves as intended **without** locking out real users.

## The four stages

### 1. Report-only

Every pattern ships as `enabledForReportingButNotEnforced`. Entra evaluates the policy on
every sign-in and logs what it *would* have done, but enforces nothing.

```bash
terraform apply -target=azuread_conditional_access_policy.<name>
```

### 2. Review (about 7 days)

Let real sign-in traffic accumulate, then inspect:

- **Entra → Conditional Access → Policies → (policy) → Insights and reporting** — the
  report-only workbook shows would-be results (success / failure / not applied).
- **Entra → Monitoring → Sign-in logs** — per-sign-in, open the *Conditional Access* and
  *Report-only* tabs to see how each policy evaluated.

Look for legitimate users or admins who *would* have been blocked. Each is either an
intended exception (add to the exclusion) or a signal the policy is too broad.

### 3. Pilot (optional)

Before all-users enforcement on a broad policy, scope it to a small test group, enforce
for that group, and confirm real behavior matches the report-only prediction.

### 4. Enforce

Change `state` to `enabled` in the pattern's `.tf` and re-apply:

```hcl
state = "enabled"
```

```bash
terraform apply -target=azuread_conditional_access_policy.<name>
```

## Per-pattern test scenarios

Each pattern folder has a `test-scenarios.md` with a table of expected outcomes (normal
user, targeted condition, break-glass, out-of-scope). Work through that table during the
review stage.

## Pre-enforcement checklist

Before flipping any policy to `enabled`:

- [ ] Report-only reviewed for at least ~7 days.
- [ ] No legitimate user or admin appears as "would block" without an intended exclusion.
- [ ] Both break-glass accounts confirmed in the policy's `excludeUsers`.
- [ ] For device policies (07): at least one compliant/hybrid device exists.
- [ ] For MFA/auth-strength policies (02, 03): in-scope users have a valid method registered.
- [ ] Rollback path confirmed (set `state` back to `disabled` / report-only, re-apply).

## Verifying a live policy

```powershell
Get-MgIdentityConditionalAccessPolicy |
  Select-Object DisplayName, State

# Confirm break-glass exclusion on a specific policy
(Get-MgIdentityConditionalAccessPolicy -ConditionalAccessPolicyId <id>).Conditions.Users.ExcludeUsers
```

## Rollback

Setting `state` to `disabled` or `enabledForReportingButNotEnforced` and re-applying
reverts enforcement immediately. Conditional Access changes take effect within minutes;
existing sessions are re-evaluated according to the policy's session controls.