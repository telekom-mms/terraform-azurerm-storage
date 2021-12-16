variable "resource_name" {
  type        = any
  default     = {}
  description = "Azure Storage Account"
}
variable "location" {
  type        = string
  description = "location where the resource should be created"
}
variable "resource_group_name" {
  type        = string
  description = "resource_group whitin the resource should be created"
}
variable "tags" {
  type        = any
  default     = {}
  description = "mapping of tags to assign, default settings are defined within locals and merged with var settings"
}
# resource definition
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
# resource configuration
variable "storage_account_config" {
  type        = any
  default     = {}
  description = "resource configuration, default settings are defined within locals and merged with var settings"
}
variable "storage_share_config" {
  type        = any
  default     = {}
  description = "resource configuration, default settings are defined within locals and merged with var settings"
}

locals {
  default = {
    tags = {}
    # resource definition
    storage_account = {
      account_kind              = "StorageV2"
      account_tier              = "Standard"
      account_replication_type  = "ZRS"
      access_tier               = "Hot"
      enable_https_traffic_only = true
      allow_blob_public_access  = false
      shared_access_key_enabled = true
    }
    storage_container = {
      container_access_type = "private"
    }
    storage_share = {
      metadata = {}
      quota    = "50"
    }
    storage_share_directory = {
      metadata = {}
    }

    # resource configuration
    storage_account_config = {
      static_website = {
        index_document     = "index.html"
        error_404_document = "404.html"
      }
    }
    storage_share_config = {
      acl = {
        permissions = "rl"
        start       = ""
        expiry      = ""
      }
    }
  }

  # merge custom and default values
  tags                    = merge(local.default.tags, var.tags)
  storage_account         = merge(local.default.storage_account, var.storage_account)

  # deep merge over custom and default values
  storage_account_config = {
    # get all config
    for config in keys(var.storage_account_config) :
    config => merge(local.default.storage_account_config, var.storage_account_config[config])
  }
  storage_container = {
    # get all config
    for config in keys(var.storage_container) :
    config => merge(local.default.storage_container, var.storage_container[config])
  }
  storage_share = {
    # get all config
    for config in keys(var.storage_share) :
    config => merge(local.default.storage_share, var.storage_share[config])
  }
  storage_share_config = {
    # get all config
    for config in keys(var.storage_share_config) :
    config => merge(local.default.storage_share_config, var.storage_share_config[config])
  }
  storage_share_directory = {
    # get all config
    for config in keys(var.storage_share_directory) :
    config => merge(local.default.storage_share_directory, var.storage_share_directory[config])
  }
}
