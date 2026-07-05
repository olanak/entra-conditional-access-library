resource "azuread_conditional_access_policy" "ca07_compliant_device_admins" {
  display_name = "CA07 - Require Compliant Device for Admins"
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
    operator          = "OR"
    built_in_controls = ["compliantDevice", "domainJoinedDevice"]
  }
}