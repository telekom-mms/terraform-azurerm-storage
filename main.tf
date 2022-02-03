/**
 * # storage
 *
 * This module manages Azure Storage Configuration.
 *
*/
resource "azurerm_storage_account" "storage_account" {
  for_each = var.storage_account

  name     = local.storage_account[each.key].name == "" ? each.key : local.storage_account[each.key].name
  location = local.storage_account[each.key].location
  resource_group_name       = local.storage_account[each.key].resource_group_name
  account_kind              = local.storage_account[each.key].account_kind
  account_tier              = local.storage_account[each.key].account_tier
  account_replication_type  = local.storage_account[each.key].account_replication_type
  access_tier               = local.storage_account[each.key].access_tier
  enable_https_traffic_only = local.storage_account[each.key].enable_https_traffic_only
  allow_blob_public_access  = local.storage_account[each.key].allow_blob_public_access
  shared_access_key_enabled = local.storage_account[each.key].shared_access_key_enabled

  dynamic "static_website" {
    /** is static website config set and should be enabled */
    for_each = local.storage_account[each.key].static_website == true ? [1] : []
    content {
      index_document     = local.storage_account[each.key].static_website[static_website.key].index_document
      error_404_document = local.storage_account[each.key].static_website[static_website.key].error_404_document
    }
  }

  tags = local.storage_account[each.key].tags
}

resource "azurerm_storage_container" "storage_container" {
  for_each = var.storage_container

  name                  = local.storage_container[each.key].name == "" ? each.key : local.storage_container[each.key].name
  storage_account_name  = local.storage_container[each.key].storage_account_name
  container_access_type = local.storage_container[each.key].container_access_type
}

resource "azurerm_storage_share" "storage_share" {
  for_each = var.storage_share

  name                 = local.storage_share[each.key].name == "" ? each.key : local.storage_share[each.key].name
  metadata             = local.storage_share[each.key].metadata
  storage_account_name = local.storage_share[each.key].storage_account_name
  quota                = local.storage_share[each.key].quota

  dynamic "acl" {
    for_each = local.storage_account[each.key].acl == true ? [1] : []
    content {
      id = local.storage_account[each.key].acl[acl.key].id

      dynamic "access_policy" {
        for_each = local.storage_account[each.key].acl[acl.key].access_policy
        content {
          permissions = local.storage_account[each.key].acl[acl.key].access_policy[access_policy.key].permissions
          start       = local.storage_account[each.key].acl[acl.key].access_policy[access_policy.key].start
          expiry      = local.storage_account[each.key].acl[acl.key].access_policy[access_policy.key].expiry
        }
      }
    }
  }
}

resource "azurerm_storage_share_directory" "storage_share_directory" {
  for_each = var.storage_share_directory

  name                 = local.storage_share_directory[each.key].name == "" ? each.key : local.storage_share_directory[each.key].name
  metadata             = local.storage_share_directory[each.key].metadata
  share_name           = local.storage_share_directory[each.key].share_name
  storage_account_name = local.storage_share_directory[each.key].storage_account_name
}
