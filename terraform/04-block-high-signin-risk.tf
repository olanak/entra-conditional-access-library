resource "azuread_conditional_access_policy" "ca04_block_high_signin_risk" {
  display_name = "CA04 - Block High Sign-in Risk"
  state        = local.default_state

  conditions {
    client_app_types    = ["all"]
    sign_in_risk_levels = ["high"]

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
    built_in_controls = ["block"]
  }
}