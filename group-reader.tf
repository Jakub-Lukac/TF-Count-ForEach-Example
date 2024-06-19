locals {
  reader_users = { for user in var.reader_users : user => user }
}

# in this case we user azuread_users (plural), but then we have to use count and not for_each
# also we can not use map, but we have to use list
data "azuread_users" "readers" {
  user_principal_names = var.reader_users
}

resource "azuread_group" "readers" {
  display_name     = "${var.application_name}-${var.environment_name} Readers"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}

resource "azuread_group_member" "readers" {
  count            = length(var.reader_users)
  group_object_id  = azuread_group.readers.object_id
  # object_ids - (Optional) The object IDs of the groups.
  member_object_id = data.azuread_users.readers.object_ids[count.index]
}
