data "azuread_client_config" "current" {}

locals {
  group_owners = setunion([data.azuread_client_config.current.object_id], data.azuread_users.owners.object_ids)
}

data "azuread_users" "owners" {
  user_principal_names = var.owners
}