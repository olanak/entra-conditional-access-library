# Pattern 14 — App-Enforced Restrictions: Test Scenarios

**Policy:** CA14 - App-Enforced Restrictions (SPO/EXO)
**State:** report-only → enforce after SPO/EXO limited-access config
**ATT&CK:** T1567
**License:** P1+

| # | Scenario | Expected (enforced, with SPO/EXO config) |
|---|----------|-------------------------------------------|
| 1 | SharePoint via browser on managed device | Full access |
| 2 | SharePoint via browser on unmanaged device | Web-only, no download/sync |
| 3 | Access to a non-SPO/EXO app | Out of scope (control not honored) |
| 4 | Break-glass account | Allowed (excluded) |

## Configuration dependency
Requires SharePoint/OneDrive "unmanaged devices" limited access + Exchange OWA policy set.
Without it, the policy applies but the app shows no reduced experience.

## Report-only validation
- Sign-in logs → filter SPO/EXO → confirm session control appears.
- Test with an unmanaged browser session once SPO limited access is configured.

## Rollback
Set `state` to `disabled`, re-run apply.