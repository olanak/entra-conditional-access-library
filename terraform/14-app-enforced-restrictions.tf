resource "azuread_conditional_access_policy" "ca14_app_enforced_restrictions" {
  display_name = "CA14 - App-Enforced Restrictions (SPO/EXO)"
  state        = local.default_state

  conditions {
    client_app_types = ["browser"]

    applications {
      # App-enforced restrictions are honored only by Exchange Online + SharePoint Online
      included_applications = [
        "00000002-0000-0ff1-ce00-000000000000", # Office 365 Exchange Online
        "00000003-0000-0ff1-ce00-000000000000", # Office 365 SharePoint Online
      ]
    }

    users {
      included_users = ["All"]
      excluded_users = var.break_glass_object_ids
    }
  }

  session_controls {
    application_enforced_restrictions_enabled = true
  }
}