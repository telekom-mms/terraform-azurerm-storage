output "storage_account" {
  description = "Outputs all attributes of resource_type."
  value = {
    for storage_account in keys(azurerm_storage_account.storage_account) :
    storage_account => {
      for key, value in azurerm_storage_account.storage_account[storage_account] :
      key => value
    }
  }
}

output "storage_container" {
  description = "Outputs all attributes of resource_type."
  value = {
    for storage_container in keys(azurerm_storage_container.storage_container) :
    storage_container => {
      for key, value in azurerm_storage_container.storage_container[storage_container] :
      key => value
    }
  }
}

output "storage_share" {
  description = "Outputs all attributes of resource_type."
  value = {
    for storage_share in keys(azurerm_storage_share.storage_share) :
    storage_share => {
      for key, value in azurerm_storage_share.storage_share[storage_share] :
      key => value
    }
  }
}

output "storage_share_directory" {
  description = "Outputs all attributes of resource_type."
  value = {
    for storage_share_directory in keys(azurerm_storage_share_directory.storage_share_directory) :
    storage_share_directory => {
      for key, value in azurerm_storage_share_directory.storage_share_directory[storage_share_directory] :
      key => value
    }
  }
}

output "variables" {
  description = "Displays all configurable variables passed by the module. __default__ = predefined values per module. __merged__ = result of merging the default values and custom values passed to the module"
  value = {
    default = {
      for variable in keys(local.default) :
      variable => local.default[variable]
    }
    merged = {
      storage_account = {
        for key in keys(var.storage_account) :
        key => local.storage_account[key]
      }
      storage_container = {
        for key in keys(var.storage_container) :
        key => local.storage_container[key]
      }
      storage_share = {
        for key in keys(var.storage_share) :
        key => local.storage_share[key]
      }
      storage_share_directory = {
        for key in keys(var.storage_share_directory) :
        key => local.storage_share_directory[key]
      }
    }
  }
}
