/**
 * # storage
 *
 * This module manages Azure Storage Configuration.
 *
*/
resource "azurerm_storage_account" "storage_account" {
  for_each = var.storage_account

  name                              = local.storage_account[each.key].name == "" ? each.key : local.storage_account[each.key].name
  location                          = local.storage_account[each.key].location
  resource_group_name               = local.storage_account[each.key].resource_group_name
  account_kind                      = local.storage_account[each.key].account_kind
  account_tier                      = local.storage_account[each.key].account_tier
  account_replication_type          = local.storage_account[each.key].account_replication_type
  cross_tenant_replication_enabled  = local.storage_account[each.key].cross_tenant_replication_enabled
  access_tier                       = local.storage_account[each.key].access_tier
  edge_zone                         = local.storage_account[each.key].edge_zone
  enable_https_traffic_only         = local.storage_account[each.key].enable_https_traffic_only
  min_tls_version                   = local.storage_account[each.key].min_tls_version
  allow_nested_items_to_be_public   = local.storage_account[each.key].allow_nested_items_to_be_public
  shared_access_key_enabled         = local.storage_account[each.key].shared_access_key_enabled
  is_hns_enabled                    = local.storage_account[each.key].is_hns_enabled
  nfsv3_enabled                     = local.storage_account[each.key].nfsv3_enabled
  large_file_share_enabled          = local.storage_account[each.key].large_file_share_enabled
  queue_encryption_key_type         = local.storage_account[each.key].queue_encryption_key_type
  table_encryption_key_type         = local.storage_account[each.key].table_encryption_key_type
  infrastructure_encryption_enabled = local.storage_account[each.key].infrastructure_encryption_enabled

  dynamic "custom_domain" {
    for_each = local.storage_account[each.key].custom_domain.name != "" ? [1] : []
    content {
      name          = local.storage_account[each.key].custom_domain.name
      use_subdomain = local.storage_account[each.key].custom_domain.use_subdomain
    }
  }

  dynamic "customer_managed_key" {
    for_each = local.storage_account[each.key].customer_managed_key != {} ? [1] : []
    content {
      key_vault_key_id          = local.storage_account[each.key].customer_managed_key.key_vault_key_id
      user_assigned_identity_id = local.storage_account[each.key].customer_managed_key.user_assigned_identity_id
    }
  }

  dynamic "identity" {
    for_each = local.storage_account[each.key].identity.type != "" ? [1] : []
    content {
      type         = local.storage_account[each.key].identity.type
      identity_ids = local.storage_account[each.key].identity.identity_ids
    }
  }

  dynamic "blob_properties" {
    for_each = local.storage_account[each.key].account_kind != "FileStorage" ? [1] : []
    content {
      versioning_enabled       = local.storage_account[each.key].blob_properties.versioning_enabled
      change_feed_enabled      = local.storage_account[each.key].blob_properties.change_feed_enabled
      default_service_version  = local.storage_account[each.key].blob_properties.default_service_version
      last_access_time_enabled = local.storage_account[each.key].blob_properties.last_access_time_enabled
      dynamic "cors_rule" {
        for_each = local.storage_account[each.key].blob_properties.cors_rule
        content {
          allowed_headers    = local.storage_account[each.key].blob_properties.cors_rule[cors_rule.key].allowed_headers
          allowed_methods    = local.storage_account[each.key].blob_properties.cors_rule[cors_rule.key].allowed_methods
          allowed_origins    = local.storage_account[each.key].blob_properties.cors_rule[cors_rule.key].allowed_origins
          exposed_headers    = local.storage_account[each.key].blob_properties.cors_rule[cors_rule.key].exposed_headers
          max_age_in_seconds = local.storage_account[each.key].blob_properties.cors_rule[cors_rule.key].max_age_in_seconds
        }
      }
      dynamic "delete_retention_policy" {
        for_each = local.storage_account[each.key].blob_properties.delete_retention_policy
        content {
          days = local.storage_account[each.key].blob_properties.delete_retention_policy.days
        }
      }
      dynamic "container_delete_retention_policy" {
        for_each = local.storage_account[each.key].blob_properties.container_delete_retention_policy
        content {
          days = local.storage_account[each.key].blob_properties.container_delete_retention_policy.days
        }
      }
    }
  }

  dynamic "queue_properties" {
    for_each = local.storage_account[each.key].queue_properties.cors_rule != {} || local.storage_account[each.key].queue_properties.logging != {} || local.storage_account[each.key].queue_properties.minute_metrics != {} || local.storage_account[each.key].queue_properties.hour_metrics != {} ? [1] : []  
    content {
      dynamic "cors_rule" {
        for_each = local.storage_account[each.key].queue_properties.cors_rule
        content {
          allowed_headers    = local.storage_account[each.key].queue_properties.cors_rule[cors_rule.key].allowed_headers
          allowed_methods    = local.storage_account[each.key].queue_properties.cors_rule[cors_rule.key].allowed_methods
          allowed_origins    = local.storage_account[each.key].queue_properties.cors_rule[cors_rule.key].allowed_origins
          exposed_headers    = local.storage_account[each.key].queue_properties.cors_rule[cors_rule.key].exposed_headers
          max_age_in_seconds = local.storage_account[each.key].queue_properties.cors_rule[cors_rule.key].max_age_in_seconds
        }
      }
      dynamic "logging" {
        for_each = local.storage_account[each.key].queue_properties.logging
        content {
          delete                = local.storage_account[each.key].queue_properties.logging.delete
          read                  = local.storage_account[each.key].queue_properties.logging.read
          version               = local.storage_account[each.key].queue_properties.logging.version
          write                 = local.storage_account[each.key].queue_properties.logging.write
          retention_policy_days = local.storage_account[each.key].queue_properties.logging.retention_policy_days
        }
      }
      dynamic "minute_metrics" {
        for_each = local.storage_account[each.key].queue_properties.minute_metrics
        content {
          enabled               = local.storage_account[each.key].queue_properties.minute_metrics.enabled
          version               = local.storage_account[each.key].queue_properties.minute_metrics.version
          include_apis          = local.storage_account[each.key].queue_properties.minute_metrics.include_apis
          retention_policy_days = local.storage_account[each.key].queue_properties.minute_metrics.retention_policy_days
        }
      }
      dynamic "hour_metrics" {
        for_each = local.storage_account[each.key].queue_properties.hour_metrics
        content {
          enabled               = local.storage_account[each.key].queue_properties.hour_metrics.enabled
          version               = local.storage_account[each.key].queue_properties.hour_metrics.version
          include_apis          = local.storage_account[each.key].queue_properties.hour_metrics.include_apis
          retention_policy_days = local.storage_account[each.key].queue_properties.hour_metrics.retention_policy_days
        }
      }
    }
  }

  dynamic "static_website" {
    /** is static website config set and should be enabled */
    for_each = local.storage_account[each.key].static_website != {} ? [1] : []
    content {
      index_document     = local.storage_account[each.key].static_website.index_document
      error_404_document = local.storage_account[each.key].static_website.error_404_document
    }
  }

  dynamic "network_rules" {
    for_each = local.storage_account[each.key].network_rules.default_action != "" ? [1] : []
    content {
      default_action             = local.storage_account[each.key].network_rules.default_action
      bypass                     = local.storage_account[each.key].network_rules.bypass
      ip_rules                   = local.storage_account[each.key].network_rules.ip_rules
      virtual_network_subnet_ids = local.storage_account[each.key].network_rules.virtual_network_subnet_ids
      dynamic "private_link_access" {
        for_each = local.storage_account[each.key].network_rules.private_link_access
        content {
          endpoint_resource_id = local.storage_account[each.key].network_rules.private_link_access[private_link_access.key].endpoint_resource_id
          endpoint_tenant_id   = local.storage_account[each.key].network_rules.private_link_access[private_link_access.key].endpoint_tenant_id
        }
      }
    }
  }

  dynamic "azure_files_authentication" {
    for_each = local.storage_account[each.key].azure_files_authentication.directory_type != "" ? [1] : []
    content {
      directory_type = local.storage_account[each.key].azure_files_authentication.directory_type

      dynamic "active_directory" {
        for_each = local.storage_account[each.key].azure_files_authentication.active_directory != {} ? [1] : []
        content {
          storage_sid         = local.storage_account[each.key].azure_files_authentication.active_directory.storage_sid
          domain_name         = local.storage_account[each.key].azure_files_authentication.active_directory.domain_name
          domain_sid          = local.storage_account[each.key].azure_files_authentication.active_directory.domain_sid
          domain_guid         = local.storage_account[each.key].azure_files_authentication.active_directory.domain_guid
          forest_name         = local.storage_account[each.key].azure_files_authentication.active_directory.forest_name
          netbios_domain_name = local.storage_account[each.key].azure_files_authentication.active_directory.netbios_domain_name
        }
      }
    }
  }

  dynamic "routing" {
    for_each = local.storage_account[each.key].routing != {} ? [1] : []
    content {
      publish_internet_endpoints  = local.storage_account[each.key].routing.publish_internet_endpoints
      publish_microsoft_endpoints = local.storage_account[each.key].routing.publish_microsoft_endpoints
      choice                      = local.storage_account[each.key].routing.choice
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
  access_tier = local.storage_share[each.key].access_tier
  enabled_protocol = local.storage_share[each.key].enabled_protocol
  quota                = local.storage_share[each.key].quota

  dynamic "acl" {
    for_each = local.storage_share[each.key].acl != {} ? [1] : []
    content {
      id = local.storage_account[each.key].acl[acl.key].id

      dynamic "access_policy" {
        for_each = local.storage_share[each.key].acl[acl.key].access_policy != {} ? [1] : []
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
