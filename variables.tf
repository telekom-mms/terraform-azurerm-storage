variable "storage_account" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
variable "storage_container" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
variable "storage_share" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
variable "storage_share_directory" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}

locals {
  default = {
    # resource definition
    storage_account = {
      name                              = ""
      account_kind                      = "StorageV2"
      account_tier                      = "Standard"
      account_replication_type          = "ZRS"
      cross_tenant_replication_enabled  = false
      access_tier                       = "Hot"
      edge_zone                         = null
      enable_https_traffic_only         = true
      min_tls_version                   = "TLS1_2"
      allow_nested_items_to_be_public   = false
      shared_access_key_enabled         = true
      is_hns_enabled                    = null
      nfsv3_enabled                     = false
      large_file_share_enabled          = null
      queue_encryption_key_type         = null
      table_encryption_key_type         = null
      infrastructure_encryption_enabled = false
      custom_domain = {
        name          = ""
        use_subdomain = null
      }
      customer_managed_key = {}
      identity = {
        type         = ""
        identity_ids = null
      }
      blob_properties = {
        versioning_enabled                = false
        change_feed_enabled               = false
        default_service_version           = "2020-06-12"
        last_access_time_enabled          = false
        cors_rule                         = {}
        delete_retention_policy           = {}
        container_delete_retention_policy = {}
      }
      queue_properties = {
        cors_rule      = {}
        logging        = {}
        minute_metrics = {}
        hour_metrics   = {}
      }
      static_website = {}
      network_rules = {
        default_action             = ""
        bypass                     = null
        ip_rules                   = []
        virtual_network_subnet_ids = []
        private_link_access        = {}
      }
      azure_files_authentication = {
        directory_type   = ""
        active_directory = {}
      }
      routing = {}
      tags    = {}
    }
    storage_container = {
      name                  = ""
      container_access_type = "private"
      tags                  = {}
    }
    storage_share = {
      name     = ""
      metadata = {}
      access_tier = "Hot"
      enabled_protocol = null
      quota    = "50"
      acl = {
        permissions = "rl"
        start       = ""
        expiry      = ""
      }
      tags = {}
    }
    storage_share_directory = {
      name     = ""
      metadata = {}
      tags     = {}
    }
  }

  # compare and merge custom and default values
  storage_account_values = {
    for storage_account in keys(var.storage_account) :
    storage_account => merge(local.default.storage_account, var.storage_account[storage_account])
  }
  storage_account_blob_properties_values = {
    for storage_account in keys(var.storage_account) :
    storage_account => {
      blob_properties = merge(local.default.storage_account.blob_properties, local.storage_account_values[storage_account].blob_properties)
    }
  }
  storage_account_queue_properties_values = {
    for storage_account in keys(var.storage_account) :
    storage_account => {
      queue_properties = merge(local.default.storage_account.queue_properties, local.storage_account_values[storage_account].queue_properties)
    }
  }
  storage_share_values = {
    for storage_share in keys(var.storage_share) :
    storage_share => merge(local.default.storage_share, var.storage_share[storage_share])
  }

  # merge all custom and default values
  storage_account = {
    for storage_account in keys(var.storage_account) :
    storage_account => merge(
      local.storage_account_values[storage_account],
      {
        #for config in ["custom_domain", "customer_managed_key", "identity", "blob_properties", "queue_properties", "static_website", "network_rules", "azure_files_authentication", "routing", "queue_encryption_key_type", "table_encryption_key_type", "infrastructure_encryption_enabled"] :
        for config in ["custom_domain", "customer_managed_key", "identity", "static_website", "azure_files_authentication", "routing", ] :
        config => merge(local.default.storage_account[config], local.storage_account_values[storage_account][config])
      },
      {
        blob_properties = merge(
          local.storage_account_blob_properties_values[storage_account].blob_properties,
          {
            cors_rule = {
              for key in keys(local.storage_account_blob_properties_values[storage_account].blob_properties.cors_rule) :
              key => merge(local.default.storage_account.blob_properties.cors_rule, local.storage_account_blob_properties_values[storage_account].blob_properties.cors_rule[key])
            }
          }
        )
      },
      {
        queue_properties = merge(
          local.storage_account_queue_properties_values[storage_account].queue_properties,
          {
            cors_rule = {
              for key in keys(local.storage_account_queue_properties_values[storage_account].queue_properties.cors_rule) :
              key => merge(local.default.storage_account.queue_properties.cors_rule, local.storage_account_queue_properties_values[storage_account].queue_properties.cors_rule[key])
            }
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
        config => merge(local.default.storage_share[config], local.storage_share_values[storage_share][config])
      }
    )
  }
  storage_share_directory = {
    for storage_share_directory in keys(var.storage_share_directory) :
    storage_share_directory => merge(local.default.storage_share_directory, var.storage_share_directory[storage_share_directory])
  }
}
