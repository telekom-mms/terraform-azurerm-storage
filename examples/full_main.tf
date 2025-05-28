module "network" {
  source = "registry.terraform.io/telekom-mms/network/azurerm"
  virtual_network = {
    vn-app-mms = {
      location            = "westeurope"
      resource_group_name = "rg-mms-github"
      address_space       = ["173.0.0.0/23"]
    }
  }
  subnet = {
    snet-app-mms = {
      resource_group_name  = module.network.virtual_network["vn-app-mms"].resource_group_name
      address_prefixes     = ["173.0.0.0/23"]
      virtual_network_name = module.network.virtual_network["vn-app-mms"].name
      service_endpoints    = ["Microsoft.Storage"]
    }
  }
}

module "storage" {
  source = "registry.terraform.io/telekom-mms/storage/azurerm"
  storage_account = {
    stmms = {
      location            = "westeurope"
      resource_group_name = "rg-mms-github"
      network_rules = {
        ip_rules                   = ["172.0.0.2"]
        virtual_network_subnet_ids = [module.network.subnet["snet-app-mms"].id]
      }
      blob_properties = {
        last_access_time_enabled = true
      }
      tags = {
        project     = "mms-github"
        environment = terraform.workspace
        managed-by  = "terraform"
      }
    }
  }
  storage_management_policy = {
    policy = {
      storage_account_id = module.storage.storage_account.stmms.id
      rule = {
        rule1 = {
          filters = {
            blob_types   = ["blockBlob"]
            prefix_match = ["terraform"]
            match_blob_index_tag = {
              name      = "project"
              value     = "mms-github"
              operation = "=="
            }
          }
          actions = {
            base_blob = {
              tier_to_cool_after_days_since_last_access_time_greater_than = 7
              auto_tier_to_hot_from_cool_enabled                          = true
              tier_to_cold_after_days_since_modification_greater_than     = 30
            }
            snapshot = {
              tier_to_archive_after_days_since_last_tier_change_greater_than = 60
              delete_after_days_since_creation_greater_than                  = 180
            }
            version = {
              tier_to_cold_after_days_since_creation_greater_than = 30
              delete_after_days_since_creation                    = 90
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
