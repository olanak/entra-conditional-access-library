resource "azuread_conditional_access_policy" "ca01_block_legacy_auth" {
  display_name = "CA01 - Block Legacy Authentication"
  state        = local.default_state

  conditions {
    client_app_types = ["exchangeActiveSync", "other"]

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