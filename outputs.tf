output "storage_account" {
  description = "azurerm_storage_account results"
  value = {
    for storage_account in keys(azurerm_storage_account.storage_account) :
    storage_account => {
      id                     = azurerm_storage_account.storage_account[storage_account].id
      name                   = azurerm_storage_account.storage_account[storage_account].name
      resource_group_name    = azurerm_storage_account.storage_account[storage_account].resource_group_name
      primary_access_key     = azurerm_storage_account.storage_account[storage_account].primary_access_key
      primary_blob_endpoint  = azurerm_storage_account.storage_account[storage_account].primary_blob_endpoint
      primary_blob_host      = azurerm_storage_account.storage_account[storage_account].primary_blob_host
      primary_dfs_endpoint   = azurerm_storage_account.storage_account[storage_account].primary_dfs_endpoint
      primary_dfs_host       = azurerm_storage_account.storage_account[storage_account].primary_dfs_host
      primary_file_endpoint  = azurerm_storage_account.storage_account[storage_account].primary_file_endpoint
      primary_file_host      = azurerm_storage_account.storage_account[storage_account].primary_file_host
      primary_location       = azurerm_storage_account.storage_account[storage_account].primary_location
      primary_queue_endpoint = azurerm_storage_account.storage_account[storage_account].primary_queue_endpoint
      primary_queue_host     = azurerm_storage_account.storage_account[storage_account].primary_queue_host
      primary_table_endpoint = azurerm_storage_account.storage_account[storage_account].primary_table_endpoint
      primary_table_host     = azurerm_storage_account.storage_account[storage_account].primary_table_host
      primary_web_endpoint   = azurerm_storage_account.storage_account[storage_account].primary_web_endpoint
      primary_web_host       = azurerm_storage_account.storage_account[storage_account].primary_web_host
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
