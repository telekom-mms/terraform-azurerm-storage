module "container" {
  source = "registry.terraform.io/telekom-mms/storage/azurerm"
  storage_account = {
    stmms = {
      location            = "westeurope"
      resource_group_name = "rg-mms-github"
    }
  }
  storage_container = {
    terraform = {
      storage_account_name = module.storage.storage_account["stmms"].name
    }
  }
  storage_share = {
    share-mms = {
      storage_account_name = module.storage.storage_account["stmms"].name
      quota                = 5
    }
  }
  storage_share_directory = {
    files = {
      storage_account_name = module.storage.storage_account["stmms"].name
      share_name           = module.storage.storage_share["share-mms"].name
    }
  }
}
