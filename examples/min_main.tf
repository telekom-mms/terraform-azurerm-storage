module "storage" {
  source = "registry.terraform.io/telekom-mms/storage/azurerm"
  storage_account = {
    stmms = {
      location            = "westeurope"
      resource_group_name = "rg-mms-github"
    }
  }
  storage_management_policy = {
    policy = {
      storage_account_id = module.storage.storage_account.stmms.id
      rule = {
        rule1 = {
          filters = {
            blob_types = ["blockBlob"]
          }
          actions = {
            base_blob = {
              delete_after_days_since_modification_greater_than = 7
            }
          }
        }
      }
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
