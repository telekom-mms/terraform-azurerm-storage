/**
 * # storage
 *
 * This module manages Azure Storage Configuration.
 *
*/
resource "azurerm_storage_account" "storage_account" {
  for_each = var.resource_name.storage_account

  name                      = each.value
  location                  = var.location
  resource_group_name       = var.resource_group_name
  account_kind              = local.storage_account.account_kind
  account_tier              = local.storage_account.account_tier
  account_replication_type  = local.storage_account.account_replication_type
  access_tier               = local.storage_account.access_tier
  enable_https_traffic_only = local.storage_account.enable_https_traffic_only
  allow_blob_public_access  = local.storage_account.allow_blob_public_access
  shared_access_key_enabled = local.storage_account.shared_access_key_enabled

  dynamic "static_website" {
    /** is static website config set and should be enabled */
    for_each = contains(keys(var.storage_account_config), "static_website") == true ? [1] : []
    content {
      index_document     = local.storage_account_config.static_website.index_document
      error_404_document = local.storage_account_config.static_website.error_404_document
    }
  }

  tags = {
    for tag in keys(local.tags) :
    tag => local.tags[tag]
  }
}

resource "azurerm_storage_container" "storage_container" {
  for_each = var.storage_container

  name                  = each.key
  storage_account_name  = lookup(local.storage_container[each.key], "storage_account_name", azurerm_storage_account.storage_account[element(keys(var.resource_name.storage_account), 0)].name)
  container_access_type = local.storage_container[each.key].container_access_type
}

resource "azurerm_storage_share" "storage_share" {
  for_each = var.storage_share

  name                 = each.key
  metadata             = local.storage_share[each.key].metadata
  storage_account_name = lookup(local.storage_share[each.key], "storage_account_name", azurerm_storage_account.storage_account[element(keys(var.resource_name.storage_account), 0)].name)
  quota                = local.storage_share[each.key].quota

  dynamic "acl" {
    for_each = contains(keys(var.storage_share_config), "acl") == true ? [1] : []
    content {
      id = local.storage_share_config.acl[each.key].id

      dynamic "access_policy" {
        for_each = local.storage_share_config.acl[each.key].access_policy
        content {
          permissions = local.storage_share_config.acl[each.key].access_policy[access_policy.key].permissions
          start       = local.storage_share_config.acl[each.key].access_policy[access_policy.key].start
          expiry      = local.storage_share_config.acl[each.key].access_policy[access_policy.key].expiry
        }
      }
    }
  }
}

resource "azurerm_storage_share_directory" "storage_share_directory" {
  for_each = var.storage_share_directory

  name                 = each.key
  metadata             = local.storage_share_directory[each.key].metadata
  share_name           = lookup(local.storage_share_directory[each.key], "share_name", azurerm_storage_share.storage_share[element(keys(var.storage_share), 0)].name)
  storage_account_name = lookup(local.storage_share_directory[each.key], "storage_account_name", azurerm_storage_account.storage_account[element(keys(var.resource_name.storage_account), 0)].name)
}
