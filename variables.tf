variable "storage_account" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}
variable "storage_container" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}
variable "storage_share" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}
variable "storage_share_directory" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}

locals {
  default = {
    // resource definition
    storage_account = {
      name                              = ""
      account_kind                      = null
      account_tier                      = "Standard" // defined default
      account_replication_type          = "ZRS"  // defined default
      cross_tenant_replication_enabled  = false
      access_tier                       = null
      edge_zone                         = null
      enable_https_traffic_only         = null
      min_tls_version                   = null
      allow_nested_items_to_be_public   = null
      shared_access_key_enabled         = null
      public_network_access_enabled = null
      default_to_oauth_authentication = null
      is_hns_enabled                    = null
      nfsv3_enabled                     = null
      large_file_share_enabled          = null
      queue_encryption_key_type         = null
      table_encryption_key_type         = null
      infrastructure_encryption_enabled = null
      allowed_copy_scope  = null
      sftp_enabled  = null

      custom_domain = {
        name = ""
        use_subdomain = null
      }
      customer_managed_key = {}
      identity = {
        identity_ids = null
      }
      blob_properties = {
        versioning_enabled  = null
        change_feed_enabled = null
        change_feed_retention_in_days  = null
        default_service_version  = null
        last_access_time_enabled  = null
        cors_rule = {}
        delete_retention_policy = {
          days = null
        }
        restore_policy = {}
        container_delete_retention_policy = {
          days = null
        }
      }
      queue_properties = {
        cors_rule      = {}
        logging        = {
          retention_policy_days = null
        }
        minute_metrics = {
          include_apis = null
          retention_policy_days = null
        }
        hour_metrics   = {
          include_apis = null
          retention_policy_days = null
        }
      }
      static_website = {
        index_document = null
        error_404_document  = null
      }
      share_properties = {
        cors_rule = {}
        retention_policy = {
          days = null
        }
        smb = {
          versions = null
          authentication_types = null
          kerberos_ticket_encryption_type  = null
          channel_encryption_type  = null
          multichannel_enabled  = null
        }
      }
      network_rules = {
        bypass = null
        ip_rules = null
        virtual_network_subnet_ids = null
        private_link_access = {
          endpoint_tenant_id = null
        }
      }
      azure_files_authentication = {
        active_directory = {}
      }
      routing = {
        publish_internet_endpoints = null
        publish_microsoft_endpoints = null
        choice = null
      }
      immutability_policy = {}
      sas_policy  = {
        expiration_action = null
      }
      tags  = {}
    }
    storage_container = {
      name                  = ""
      container_access_type = null
      metadata                   = null
    }
    storage_share = {
      name             = ""
      access_tier      = "Hot"
      enabled_protocol = null
      metadata         = null
      acl              = {
        access_policy = {
          start = null
          expiry = null
        }
      }
    }
    storage_share_directory = {
      name     = ""
      metadata = null
    }
  }

  // compare and merge custom and default values
  storage_account_values = {
    for storage_account in keys(var.storage_account) :
    storage_account => merge(local.default.storage_account, var.storage_account[storage_account])
  }
  storage_share_values = {
    for storage_share in keys(var.storage_share) :
    storage_share => merge(local.default.storage_share, var.storage_share[storage_share])
  }

  // deep merge of all custom and default values
  storage_account = {
    for storage_account in keys(var.storage_account) :
    storage_account => merge(
      local.storage_account_values[storage_account],
      {
        for config in [
          "custom_domain",
          "customer_managed_key",
          "identity",
          "static_website",
          "azure_files_authentication",
          "routing",
          "immutability_policy",
          "sas_policy"
        ] :
        config => merge(local.default.storage_account[config], local.storage_account_values[storage_account][config])
      },
      {
        for config in ["blob_properties"] :
        config => merge(
          merge(local.default.storage_account[config], local.storage_account_values[storage_account][config]),
          {
            for subconfig in ["cors_rule", "delete_retention_policy", "restore_policy", "container_delete_retention_policy"] :
            subconfig => merge(local.default.storage_account[config][subconfig], local.storage_account_values[storage_account][config][subconfig])
          }
        )
      },
      {
        for config in ["queue_properties"] :
        config => merge(
          merge(local.default.storage_account[config], local.storage_account_values[storage_account][config]),
          {
            for subconfig in ["cors_rule", "logging", "minute_metrics", "hour_metrics"] :
            subconfig => merge(local.default.storage_account[config][subconfig], local.storage_account_values[storage_account][config][subconfig])
          }
        )
      },
      {
        for config in ["share_properties"] :
        config => merge(
          merge(local.default.storage_account[config], local.storage_account_values[storage_account][config]),
          {
            for subconfig in ["cors_rule", "retention_policy", "smb"] :
            subconfig => merge(local.default.storage_account[config][subconfig], local.storage_account_values[storage_account][config][subconfig])
          }
        )
      },
      {
        for config in ["network_rules"] :
        config => merge(
          merge(local.default.storage_account[config], local.storage_account_values[storage_account][config]),
          {
            for subconfig in ["private_link_access"] :
            subconfig => merge(local.default.storage_account[config][subconfig], local.storage_account_values[storage_account][config][subconfig])
          }
        )
      }
    )
  }
  storage_container = {
    for storage_container in keys(var.storage_container) :
    storage_container => merge(local.default.storage_container, var.storage_container[storage_container])
  }
  storage_share = {
    for storage_share in keys(var.storage_share) :
    storage_share => merge(
      local.storage_share_values[storage_share],
      {
        for config in ["acl"] :
        config => keys(local.storage_share_values[storage_share][config]) == keys(local.default.storage_share[config]) ? {} : {
          for key in keys(local.storage_share_values[storage_share][config]) :
          key => merge(local.default.storage_share[config], local.storage_share_values[storage_share][config][key])
        }
      }
    )
  }
  storage_share_directory = {
    for storage_share_directory in keys(var.storage_share_directory) :
    storage_share_directory => merge(local.default.storage_share_directory, var.storage_share_directory[storage_share_directory])
  }
}
