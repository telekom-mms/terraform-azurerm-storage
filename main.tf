/**
* # storage
*
* This module manages the hashicorp/azurerm storage resources.
* For more information see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs > storage
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
  public_network_access_enabled     = local.storage_account[each.key].public_network_access_enabled
  default_to_oauth_authentication   = local.storage_account[each.key].default_to_oauth_authentication
  is_hns_enabled                    = local.storage_account[each.key].is_hns_enabled
  nfsv3_enabled                     = local.storage_account[each.key].nfsv3_enabled
  large_file_share_enabled          = local.storage_account[each.key].large_file_share_enabled
  queue_encryption_key_type         = local.storage_account[each.key].queue_encryption_key_type
  table_encryption_key_type         = local.storage_account[each.key].table_encryption_key_type
  infrastructure_encryption_enabled = local.storage_account[each.key].infrastructure_encryption_enabled
  allowed_copy_scope                = local.storage_account[each.key].allowed_copy_scope
  sftp_enabled                      = local.storage_account[each.key].sftp_enabled

  dynamic "custom_domain" {
    for_each = flatten(compact(values(local.storage_account[each.key].custom_domain))) == [] ? [] : [0]

    content {
      name          = local.storage_account[each.key].custom_domain.name
      use_subdomain = local.storage_account[each.key].custom_domain.use_subdomain
    }
  }

  dynamic "customer_managed_key" {
    for_each = local.storage_account[each.key].customer_managed_key == {} ? [] : [0]

    content {
      key_vault_key_id          = local.storage_account[each.key].customer_managed_key.key_vault_key_id
      user_assigned_identity_id = local.storage_account[each.key].customer_managed_key.user_assigned_identity_id
    }
  }

  dynamic "identity" {
    for_each = flatten(compact(values(local.storage_account[each.key].identity))) == [] ? [] : [0]

    content {
      type         = local.storage_account[each.key].identity.type
      identity_ids = local.storage_account[each.key].identity.identity_ids
    }
  }

  dynamic "blob_properties" {
    for_each = local.storage_account[each.key].blob_properties == null ? [] : [0]

    content {
      versioning_enabled            = local.storage_account[each.key].blob_properties.versioning_enabled
      change_feed_enabled           = local.storage_account[each.key].blob_properties.change_feed_enabled
      change_feed_retention_in_days = local.storage_account[each.key].blob_properties.change_feed_retention_in_days
      default_service_version       = local.storage_account[each.key].blob_properties.default_service_version
      last_access_time_enabled      = local.storage_account[each.key].blob_properties.last_access_time_enabled

      dynamic "cors_rule" {
        for_each = local.storage_account[each.key].blob_properties.cors_rule == {} ? [] : [0]

        content {
          allowed_headers    = local.storage_account[each.key].blob_properties.cors_rule[cors_rule.key].allowed_headers
          allowed_methods    = local.storage_account[each.key].blob_properties.cors_rule[cors_rule.key].allowed_methods
          allowed_origins    = local.storage_account[each.key].blob_properties.cors_rule[cors_rule.key].allowed_origins
          exposed_headers    = local.storage_account[each.key].blob_properties.cors_rule[cors_rule.key].exposed_headers
          max_age_in_seconds = local.storage_account[each.key].blob_properties.cors_rule[cors_rule.key].max_age_in_seconds
        }
      }

      dynamic "delete_retention_policy" {
        for_each = local.storage_account[each.key].blob_properties.delete_retention_policy == {} ? [] : [0]

        content {
          days = local.storage_account[each.key].blob_properties.delete_retention_policy.days
        }
      }

      dynamic "restore_policy" {
        for_each = local.storage_account[each.key].blob_properties.restore_policy == {} ? [] : [0]

        content {
          days = local.storage_account[each.key].blob_properties.restore_policy.days
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = local.storage_account[each.key].blob_properties.container_delete_retention_policy == {} ? [] : [0]

        content {
          days = local.storage_account[each.key].blob_properties.container_delete_retention_policy.days
        }
      }
    }
  }

  dynamic "queue_properties" {
    for_each = local.storage_account[each.key].queue_properties == null ? [] : [0]

    content {
      dynamic "cors_rule" {
        for_each = local.storage_account[each.key].queue_properties.cors_rule == {} ? [] : [0]

        content {
          allowed_headers    = local.storage_account[each.key].queue_properties.cors_rule[cors_rule.key].allowed_headers
          allowed_methods    = local.storage_account[each.key].queue_properties.cors_rule[cors_rule.key].allowed_methods
          allowed_origins    = local.storage_account[each.key].queue_properties.cors_rule[cors_rule.key].allowed_origins
          exposed_headers    = local.storage_account[each.key].queue_properties.cors_rule[cors_rule.key].exposed_headers
          max_age_in_seconds = local.storage_account[each.key].queue_properties.cors_rule[cors_rule.key].max_age_in_seconds
        }
      }

      dynamic "logging" {
        for_each = flatten(compact(values(local.storage_account[each.key].queue_properties.logging))) == [] ? [] : [0]

        content {
          delete                = local.storage_account[each.key].queue_properties.logging.delete
          read                  = local.storage_account[each.key].queue_properties.logging.read
          version               = local.storage_account[each.key].queue_properties.logging.version
          write                 = local.storage_account[each.key].queue_properties.logging.write
          retention_policy_days = local.storage_account[each.key].queue_properties.logging.retention_policy_days
        }
      }

      dynamic "minute_metrics" {
        for_each = flatten(compact(values(local.storage_account[each.key].queue_properties.minute_metrics))) == [] ? [] : [0]

        content {
          enabled               = local.storage_account[each.key].queue_properties.minute_metrics.enabled
          version               = local.storage_account[each.key].queue_properties.minute_metrics.version
          include_apis          = local.storage_account[each.key].queue_properties.minute_metrics.include_apis
          retention_policy_days = local.storage_account[each.key].queue_properties.minute_metrics.retention_policy_days
        }
      }

      dynamic "hour_metrics" {
        for_each = flatten(compact(values(local.storage_account[each.key].queue_properties.hour_metrics))) == [] ? [] : [0]

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
    for_each = flatten(compact(values(local.storage_account[each.key].static_website))) == [] ? [] : [0]

    content {
      index_document     = local.storage_account[each.key].static_website.index_document
      error_404_document = local.storage_account[each.key].static_website.error_404_document
    }
  }

  dynamic "share_properties" {
    for_each = local.storage_account[each.key].share_properties == null ? [] : [0]

    content {
      dynamic "cors_rule" {
        for_each = local.storage_account[each.key].share_properties.cors_rule == {} ? [] : [0]

        content {
          allowed_headers    = local.storage_account[each.key].share_properties.cors_rule[cors_rule.key].allowed_headers
          allowed_methods    = local.storage_account[each.key].share_properties.cors_rule[cors_rule.key].allowed_methods
          allowed_origins    = local.storage_account[each.key].share_properties.cors_rule[cors_rule.key].allowed_origins
          exposed_headers    = local.storage_account[each.key].share_properties.cors_rule[cors_rule.key].exposed_headers
          max_age_in_seconds = local.storage_account[each.key].share_properties.cors_rule[cors_rule.key].max_age_in_seconds
        }
      }

      dynamic "retention_policy" {
        for_each = flatten(compact(values(local.storage_account[each.key].share_properties.retention_policy))) == [] ? [] : [0]

        content {
          days = local.storage_account[each.key].share_properties.retention_policy.days
        }
      }

      dynamic "smb" {
        for_each = flatten(compact(values(local.storage_account[each.key].share_properties.smb))) == [] ? [] : [0]

        content {
          versions                        = local.storage_account[each.key].share_properties.smb.versions
          authentication_types            = local.storage_account[each.key].share_properties.smb.authentication_types
          kerberos_ticket_encryption_type = local.storage_account[each.key].share_properties.smb.kerberos_ticket_encryption_type
          channel_encryption_type         = local.storage_account[each.key].share_properties.smb.channel_encryption_type
          multichannel_enabled            = local.storage_account[each.key].share_properties.smb.multichannel_enabled
        }
      }
    }
  }

  dynamic "network_rules" {
    for_each = local.storage_account[each.key].network_rules == null ? [] : [0]

    content {
      default_action             = local.storage_account[each.key].network_rules.default_action
      bypass                     = local.storage_account[each.key].network_rules.bypass
      ip_rules                   = local.storage_account[each.key].network_rules.ip_rules
      virtual_network_subnet_ids = local.storage_account[each.key].network_rules.virtual_network_subnet_ids

      dynamic "private_link_access" {
        for_each = flatten(compact(values(local.storage_account[each.key].network_rules.private_link_access))) == [] ? [] : [0]

        content {
          endpoint_resource_id = local.storage_account[each.key].network_rules.private_link_access.endpoint_resource_id
          endpoint_tenant_id   = local.storage_account[each.key].network_rules.private_link_access.endpoint_tenant_id
        }
      }
    }
  }

  dynamic "azure_files_authentication" {
    for_each = local.storage_account[each.key].azure_files_authentication.directory_type == "" ? [] : [0]

    content {
      directory_type = local.storage_account[each.key].azure_files_authentication.directory_type

      dynamic "active_directory" {
        for_each = local.storage_account[each.key].azure_files_authentication.active_directory

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

  dynamic "immutability_policy" {
    for_each = local.storage_account[each.key].immutability_policy == {} ? [] : [0]

    content {
      allow_protected_append_writes = local.storage_account[each.key].immutability_policy.allow_protected_append_writes
      state                         = local.storage_account[each.key].immutability_policy.state
      period_since_creation_in_days = local.storage_account[each.key].immutability_policy.period_since_creation_in_days
    }
  }

  dynamic "sas_policy" {
    for_each = flatten(compact(values(local.storage_account[each.key].sas_policy))) == [] ? [] : [0]

    content {
      expiration_period = local.storage_account[each.key].sas_policy.expiration_period
      expiration_action = local.storage_account[each.key].sas_policy.expiration_action
    }
  }

  dynamic "routing" {
    for_each = flatten(compact(values(local.storage_account[each.key].routing))) == [] ? [] : [0]

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
  metadata              = local.storage_container[each.key].metadata
}

resource "azurerm_storage_share" "storage_share" {
  for_each = var.storage_share

  name                 = local.storage_share[each.key].name == "" ? each.key : local.storage_share[each.key].name
  storage_account_name = local.storage_share[each.key].storage_account_name
  access_tier          = local.storage_share[each.key].access_tier
  enabled_protocol     = local.storage_share[each.key].enabled_protocol
  quota                = local.storage_share[each.key].quota
  metadata             = local.storage_share[each.key].metadata

  dynamic "acl" {
    for_each = local.storage_share[each.key].acl

    content {
      id = local.storage_share[each.key].acl[acl.key].id

      dynamic "access_policy" {
        for_each = local.storage_share[each.key].acl[acl.key].access_policy

        content {
          permissions = local.storage_share[each.key].acl[acl.key].access_policy[access_policy.key].permissions
          start       = local.storage_share[each.key].acl[acl.key].access_policy[access_policy.key].start
          expiry      = local.storage_share[each.key].acl[acl.key].access_policy[access_policy.key].expiry
        }
      }
    }
  }
}

resource "azurerm_storage_share_directory" "storage_share_directory" {
  for_each = var.storage_share_directory

  name                 = local.storage_share_directory[each.key].name == "" ? each.key : local.storage_share_directory[each.key].name
  share_name           = local.storage_share_directory[each.key].share_name
  storage_account_name = local.storage_share_directory[each.key].storage_account_name
  metadata             = local.storage_share_directory[each.key].metadata
}
