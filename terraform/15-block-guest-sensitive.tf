resource "azuread_conditional_access_policy" "ca15_block_guest_sensitive" {
  display_name = "CA15 - Block Guest Access to Sensitive Resources"
  state        = local.default_state

  conditions {
    client_app_types = ["all"]

    applications {
      included_applications = var.sensitive_app_ids # Azure mgmt API (from pattern 10)
    }

    users {
      included_users = ["GuestsOrExternalUsers"]
      excluded_users = var.break_glass_object_ids
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}