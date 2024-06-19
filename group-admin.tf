locals {
  admin_users = { for user in var.admin_users : user => user }
}

# using azuread_user, but populating it with a list
data "azuread_user" "admins" {
  for_each = local.admin_users
  user_principal_name = each.key
}

resource "azuread_group" "admins" {
  display_name     = "${var.application_name}-${var.environment_name} Admins"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}

resource "azuread_group_member" "admins" {
  for_each         = local.admin_users
  group_object_id  = azuread_group.admins.object_id
  member_object_id = data.azuread_user.admins[each.key].object_id
}
