resource "azuread_conditional_access_policy" "ca10_signin_frequency_sensitive" {
  display_name = "CA10 - Sign-in Frequency for Sensitive Apps"
  state        = local.default_state

  conditions {
    client_app_types = ["all"]

    applications {
      included_applications = var.sensitive_app_ids
    }

    users {
      included_users = ["All"]
      excluded_users = var.break_glass_object_ids
    }
  }

  session_controls {
    sign_in_frequency                     = 4
    sign_in_frequency_period              = "hours"
    sign_in_frequency_authentication_type = "primaryAndSecondaryAuthentication"
  }
}