resource "azuread_conditional_access_policy" "ca05_user_risk_remediation" {
  display_name = "CA05 - High User Risk - Require Password Change"
  state        = local.default_state

  conditions {
    client_app_types = ["all"]
    user_risk_levels = ["high"]

    applications {
      included_applications = ["All"]
    }

    users {
      included_users = ["All"]
      excluded_users = var.break_glass_object_ids
    }
  }

  grant_controls {
    operator          = "AND"
    built_in_controls = ["mfa", "passwordChange"]
  }


}