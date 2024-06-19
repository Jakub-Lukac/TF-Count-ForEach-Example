# in this case we user azuread_users (plural), but then we have to use count and not for_each
# also we can not use map, but we have to use list
data "azuread_users" "members" {
  user_principal_names = var.members
}

resource "azuread_group" "main" {
  display_name     = var.display_name
  owners           = local.group_owners
  security_enabled = true
}

resource "azuread_group_member" "main" {
  # when using count we have to provide the object ID (integer)
  # if we are using for_each we can provide identifier we select
  count           = length(var.members)
  group_object_id = azuread_group.main.object_id
  # object_ids - (Optional) The object IDs of the users.
  member_object_id = data.azuread_users.members.object_ids[count.index]
}
