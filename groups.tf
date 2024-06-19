#-------------------------------------------#
# Option 1 : using the module (ADMINS)
#-------------------------------------------#

module "admins" {
  source = "./modules/group-with-members"

  # ./modules/group-with-members/variables
  display_name = "${var.application_name}-${var.environment_name} Admins" # these variables refer to variable.tf outside the module
  members      = var.admin_users
  owners       = var.group_owners
}

module "readers" {
  source = "./modules/group-with-members"

  # ./modules/group-with-members/variables
  display_name = "${var.application_name}-${var.environment_name} Readers"
  members      = var.reader_users
  owners       = var.group_owners
}

#---------------------------------------------#
#               READERS
#---------------------------------------------#

# locals {
#   reader_users = { for user in var.reader_users : user => user }
#   group_owners = setunion([data.azuread_client_config.current.object_id], data.azuread_users.owners.object_ids)
# }

# # in this case we user azuread_users (plural), but then we have to use count and not for_each
# # also we can not use map, but we have to use list
# data "azuread_users" "readers" {
#   user_principal_names = var.reader_users
# }

# data "azuread_users" "owners" {
#   user_principal_names = var.group_owners
# }

# resource "azuread_group" "readers" {
#   display_name     = "${var.application_name}-${var.environment_name} Readers"
#   owners           = local.group_owners
#   security_enabled = true
# }

# resource "azuread_group_member" "readers" {
#   # when using count we have to provide the object ID (integer)
#   # if we are using for_each we can provide identifier we select
#   count           = length(var.reader_users)
#   group_object_id = azuread_group.readers.object_id
#   # object_ids - (Optional) The object IDs of the users.
#   member_object_id = data.azuread_users.readers.object_ids[count.index]
# }

#---------------------------------------------#
#               READERS END
#---------------------------------------------#

#-------------------------------------------------------------------------------------------------#

#-------------------------------------------#
# Option 2 : using the azuread_users (plural) as data source (ADMINS) - without MODULE
#-------------------------------------------#

/* locals {
  admin_users = { for user in var.admin_users : user => user }
  group_ownerss = setunion([data.azuread_client_config.current.object_id], data.azuread_users.owners.object_ids)
}

# using azuread_user, but populating it with a list
data "azuread_users" "admins" {
  user_principal_names = var.admin_users
}

data "azuread_users" "group_owners" {
  user_principal_names = var.group_owners
}

resource "azuread_group" "admins" {
  display_name     = "${var.application_name}-${var.environment_name} Admins"
  owners           = local.group_ownerss
  security_enabled = true
}

resource "azuread_group_member" "admins" {
  count           = length(var.admin_users)
  group_object_id  = azuread_group.admins.object_id
  member_object_id = data.azuread_users.admins.object_ids[count.index]
} */


#-------------------------------------------#
# Option 3 : using the azuread_user as data source + using for_each (ADMINS) - without MODULE
#-------------------------------------------#

/* locals {
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
 */
