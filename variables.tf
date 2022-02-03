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
      name                      = ""
      account_kind              = "StorageV2"
      account_tier              = "Standard"
      account_replication_type  = "ZRS"
      access_tier               = "Hot"
      enable_https_traffic_only = true
      allow_blob_public_access  = false
      shared_access_key_enabled = true
      static_website = {
        index_document     = "index.html"
        error_404_document = "404.html"
      }
      tags = {}
    }
    storage_container = {
      name                  = ""
      container_access_type = "private"
      tags                  = {}
    }
    storage_share = {
      name     = ""
      metadata = {}
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
        for config in ["static_website"] :
        config => merge(local.default.storage_account[config], local.storage_account_values[storage_account][config])
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
