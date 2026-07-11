# MITRE ATT&CK Mapping

How each pattern maps to adversary techniques. Tactic references are MITRE ATT&CK Enterprise.

| Pattern | ATT&CK Technique | Tactic | Control type |
|---------|------------------|--------|--------------|
| 01 Block legacy auth | [T1110](https://attack.mitre.org/techniques/T1110/) Brute Force / Password Spray | Credential Access (TA0006) | Preventive |
| 02 Require MFA (all users) | [T1078](https://attack.mitre.org/techniques/T1078/) Valid Accounts | Initial Access / Persistence | Preventive |
| 03 Phishing-resistant MFA (admins) | [T1621](https://attack.mitre.org/techniques/T1621/) MFA Request Generation; [T1566](https://attack.mitre.org/techniques/T1566/) Phishing | Credential Access / Initial Access | Preventive |
| 04 Block high sign-in risk | [T1090.003](https://attack.mitre.org/techniques/T1090/003/) Multi-hop Proxy (Tor); T1078 | Command & Control / Initial Access | Detective to Preventive |
| 05 High user risk → password change | [T1078](https://attack.mitre.org/techniques/T1078/) Valid Accounts (leaked creds) | Persistence | Corrective (remediation) |
| 06 Medium sign-in risk → MFA | [T1078](https://attack.mitre.org/techniques/T1078/) Valid Accounts | Initial Access | Corrective (step-up) |
| 07 Compliant device (admins) | [T1078.004](https://attack.mitre.org/techniques/T1078/004/) Cloud Accounts | Persistence | Preventive |
| 08 Location-based controls | [T1078](https://attack.mitre.org/techniques/T1078/) Valid Accounts | Initial Access | Preventive |
| 09 Require app protection policy | [T1528](https://attack.mitre.org/techniques/T1528/) Steal Application Access Token | Credential Access | Preventive |
| 10 Sign-in frequency (sensitive apps) | [T1550.001](https://attack.mitre.org/techniques/T1550/001/) Application Access Token | Defense Evasion / Lateral Movement | Preventive |
| 11 Require admin consent for OAuth apps | [T1528](https://attack.mitre.org/techniques/T1528/) Steal Application Access Token | Credential Access | Preventive |
| 12 Secure security-info registration | [T1556.006](https://attack.mitre.org/techniques/T1556/006/) Modify Auth Process: MFA; [T1098.005](https://attack.mitre.org/techniques/T1098/005/) Device Registration | Credential Access / Persistence | Preventive |
| 13 Workload identity CA (license-gated) | [T1078.004](https://attack.mitre.org/techniques/T1078/004/) Valid Accounts: Cloud Accounts | Persistence / Defense Evasion | Preventive |

## Coverage notes

- **Credential Access (TA0006):** patterns 01, 03, 09, 11 — the primary defensive cluster.
- **Valid Accounts (T1078) family:** patterns 02, 04, 05, 06, 07, 08, 13 — layered by signal
  (identity, session risk, account risk, device, location, and non-human workload identity).
- **Application Access Token (T1528 / T1550.001):** patterns 09, 10, 11 — protect the token
  layer via app protection, short session lifetime, and consent restriction.
- **Authentication-process integrity:** pattern 12 secures MFA method registration against
  attacker-controlled enrollment (T1556.006 / T1098.005).
- **Risk tiers:** 04 (high sign-in → block), 06 (medium sign-in → MFA), 05 (high user → password change)
  form a graduated response rather than a single blunt block.

Rows are appended as new patterns ship.