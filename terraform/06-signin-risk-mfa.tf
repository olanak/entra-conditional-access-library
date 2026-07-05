resource "azuread_conditional_access_policy" "ca06_signin_risk_mfa" {
  display_name = "CA06 - Medium Sign-in Risk - Require MFA"
  state        = local.default_state

  conditions {
    client_app_types    = ["all"]
    sign_in_risk_levels = ["medium"]

    applications {
      included_applications = ["All"]
    }

    users {
      included_users = ["All"]
      excluded_users = var.break_glass_object_ids
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["mfa"]
  }

  session_controls {
    sign_in_frequency                     = 1
    sign_in_frequency_period              = "hours"
    sign_in_frequency_authentication_type = "primaryAndSecondaryAuthentication"
  }
}