resource "azuread_group" "readers" {
  display_name     = "${var.application_name}-${var.environment_name} Readers"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}

resource "azuread_group_member" "readers" {
  count            = length(var.reader_users)
  group_object_id  = azuread_group.readers.object_id
  member_object_id = var.reader_users[count.index]
}