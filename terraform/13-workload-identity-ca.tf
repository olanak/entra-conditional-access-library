# NOTE: Requires Workload Identities Premium (separate SKU, not in P2).
# Do not `terraform apply` without that license — the API will reject client_applications.
# Kept out of the default apply until protected_service_principal_ids is populated.

resource "azuread_conditional_access_policy" "ca13_workload_identity_location" {
  count        = length(var.protected_service_principal_ids) > 0 ? 1 : 0
  display_name = "CA13 - Block Service Principal from Untrusted Locations"
  state        = local.default_state

  conditions {
    client_app_types = ["all"]

    applications {
      included_applications = ["All"]
    }

    users {
      included_users = ["None"]
      excluded_users = var.break_glass_object_ids
    }


    # Workload identities: policy targets service principals, not users
    client_applications {
      included_service_principals = var.protected_service_principal_ids
      excluded_service_principals = []
    }

    locations {
      included_locations = ["All"]
      excluded_locations = [azuread_named_location.allowed_countries.object_id]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"] # Block is the ONLY grant control valid for workload identities
  }
}