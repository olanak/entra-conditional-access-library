resource "azuread_conditional_access_policy" "ca12_secure_security_info_registration" {
  display_name = "CA12 - Secure Security Info Registration (Trusted Locations Only)"
  state        = local.default_state

  conditions {
    client_app_types = ["all"]

    applications {
      # User action, not an app: triggers when registering/changing security info (MFA methods)
      included_user_actions = ["urn:user:registersecurityinfo"]
    }

    users {
      included_users = ["All"]
      excluded_users = var.break_glass_object_ids
    }

    locations {
      included_locations = ["All"]
      excluded_locations = [azuread_named_location.allowed_countries.object_id]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}