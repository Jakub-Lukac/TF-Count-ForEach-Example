locals {
  admin_users = { for user in var.admin_users : user => user }
  # concat the currently logged in user with variable of group owners
  # distinct to remove duplicate values
  combined_owners = distinct(
    concat(
      [data.azuread_client_config.current.object_id], # concat expect list as arguments, thats why have single element list
      data.azuread_user.group_owners.*.object_id # * - splat operator creates list
      )
    )
}

# using azuread_user, but populating it with a list
data "azuread_user" "admins" {
  for_each            = local.admin_users
  user_principal_name = each.key
}

data "azuread_user" "group_owners" {
  count            = length(var.group_owners)
  user_principal_name = var.group_owners[count.index]
}

resource "azuread_group" "admins" {
  display_name     = "${var.application_name}-${var.environment_name} Admins"
  owners           = local.combined_owners
  security_enabled = true
}

resource "azuread_group_member" "admins" {
  for_each         = local.admin_users
  group_object_id  = azuread_group.admins.object_id
  member_object_id = data.azuread_user.admins[each.key].object_id
}
