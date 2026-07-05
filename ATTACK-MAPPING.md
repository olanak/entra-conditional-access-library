# MITRE ATT&CK Mapping

How each Conditional Access pattern maps to adversary techniques. Tactic references are
MITRE ATT&CK Enterprise.

| Pattern | ATT&CK Technique | Tactic | Control type |
|---------|------------------|--------|--------------|
| 01 Block legacy auth | [T1110](https://attack.mitre.org/techniques/T1110/) Brute Force / Password Spray | Credential Access (TA0006) | Preventive |
| 02 Require MFA (all users) | [T1078](https://attack.mitre.org/techniques/T1078/) Valid Accounts | Initial Access / Persistence | Preventive |
| 03 Phishing-resistant MFA (admins) | [T1621](https://attack.mitre.org/techniques/T1621/) MFA Request Generation; [T1566](https://attack.mitre.org/techniques/T1566/) Phishing | Credential Access / Initial Access | Preventive |
| 04 Block high sign-in risk | [T1090.003](https://attack.mitre.org/techniques/T1090/003/) Multi-hop Proxy (Tor); T1078 | Command & Control / Initial Access | Detective to Preventive |
| 05 High user risk → password change | [T1078](https://attack.mitre.org/techniques/T1078/) Valid Accounts (leaked creds) | Persistence | Corrective (remediation) |
| 06 Medium sign-in risk → MFA | [T1078](https://attack.mitre.org/techniques/T1078/) Valid Accounts | Initial Access | Corrective (step-up) |
| 07 Compliant device (admins) | [T1078.004](https://attack.mitre.org/techniques/T1078/004/) Cloud Accounts | Persistence | Preventive |

## Coverage notes

- **Credential Access (TA0006):** patterns 01, 03 — the primary defensive cluster.
- **Valid Accounts (T1078) family:** patterns 02, 04, 05, 06, 07 — layered by signal
  (identity, session risk, account risk, device).
- **Risk tiers:** 04 (high sign-in → block), 06 (medium sign-in → MFA), 05 (high user → password change)
  form a graduated response rather than a single blunt block.

Rows are appended as new patterns ship.