resource "azuread_conditional_access_policy" "ca02_require_mfa_all" {
  display_name = "CA02 - Require MFA for All Users"
  state        = local.default_state

  conditions {
    client_app_types = ["all"]

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
}