output "storage_account" {
  description = "azurerm_storage_account results"
  value = {
    for storage_account in keys(azurerm_storage_account.storage_account) :
    storage_account => {
      id                   = azurerm_storage_account.storage_account[storage_account].id
      name                 = azurerm_storage_account.storage_account[storage_account].name
      resource_group_name  = azurerm_storage_account.storage_account[storage_account].resource_group_name
      primary_access_key   = azurerm_storage_account.storage_account[storage_account].primary_access_key
      primary_web_endpoint = azurerm_storage_account.storage_account[storage_account].primary_web_endpoint
    }
  }
}

output "storage_container" {
  description = "azurerm_storage_container results"
  value = {
    for storage_container in keys(azurerm_storage_container.storage_container) :
    storage_container => {
      id                   = azurerm_storage_container.storage_container[storage_container].id
      name                 = azurerm_storage_container.storage_container[storage_container].name
      storage_account_name = azurerm_storage_container.storage_container[storage_container].storage_account_name
    }
  }
}
