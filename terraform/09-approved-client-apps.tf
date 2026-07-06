resource "azuread_conditional_access_policy" "ca09_approved_client_apps" {
  display_name = "CA09 - Require Approved Client Apps (Mobile/Desktop)"
  state        = local.default_state

  conditions {
    # App-protection controls apply to mobile + desktop clients, not browser
    client_app_types = ["mobileAppsAndDesktopClients"]

    applications {
      included_applications = ["Office365"]
    }

    users {
      included_users = ["All"]
      excluded_users = var.break_glass_object_ids
    }

    platforms {
      included_platforms = ["android", "iOS"]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["approvedApplication"]
  }
}