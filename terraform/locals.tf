locals {
  default_state = "enabledForReportingButNotEnforced"

  # Countries permitted to sign in — adjust to your operating geography
  allowed_countries = ["TR", "ET", "DE"]

  # Built-in authentication strength policies — provider expects the full ID path
  builtin_auth_strength = {
    mfa                = "/policies/authenticationStrengthPolicies/00000000-0000-0000-0000-000000000002"
    passwordless_mfa   = "/policies/authenticationStrengthPolicies/00000000-0000-0000-0000-000000000003"
    phishing_resistant = "/policies/authenticationStrengthPolicies/00000000-0000-0000-0000-000000000004"
  }
}