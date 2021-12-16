output "storage_account" {
  description = "azurerm_storage_account results"
  value = {
    for storage_account in keys(azurerm_storage_account.storage_account) :
    storage_account => {
      id                   = azurerm_storage_account.storage_account[storage_account].id
      name                 = azurerm_storage_account.storage_account[storage_account].name
      primary_access_key   = azurerm_storage_account.storage_account[storage_account].primary_access_key
      primary_web_endpoint = azurerm_storage_account.storage_account[storage_account].primary_web_endpoint
    }
  }
}
