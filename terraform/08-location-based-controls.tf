# Named location: trusted countries
resource "azuread_named_location" "allowed_countries" {
  display_name = "Allowed Countries"

  country {
    countries_and_regions                 = local.allowed_countries
    include_unknown_countries_and_regions = false
  }
}

resource "time_sleep" "wait_for_named_location" {
  depends_on      = [azuread_named_location.allowed_countries]
  create_duration = "15s"
}

# Policy: block sign-in from anywhere NOT in the allowed list
resource "azuread_conditional_access_policy" "ca08_block_untrusted_locations" {
  display_name = "CA08 - Block Sign-in from Untrusted Locations"
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

    locations {
      included_locations = ["All"]
      excluded_locations = [azuread_named_location.allowed_countries.object_id]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
  # Wait for the named location to be fully created before applying the conditional access policy
  depends_on = [time_sleep.wait_for_named_location]
}

