resource "azuread_conditional_access_policy" "ca03_phishing_resistant_admins" {
  display_name = "CA03 - Phishing-Resistant MFA for Admins"
  state        = local.default_state

  conditions {
    client_app_types = ["all"]

    applications {
      included_applications = ["All"]
    }

    users {
      included_roles = values(var.admin_role_template_ids)
      excluded_users = var.break_glass_object_ids
    }
  }

  grant_controls {
    operator                          = "OR"
    authentication_strength_policy_id = local.builtin_auth_strength.phishing_resistant
  }
}