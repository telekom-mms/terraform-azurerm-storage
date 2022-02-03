module "storage" {
  source              = "../terraform-storage"
  storage_account = {
    mgmt = {
      name = "servicemgmtstg"
      resource_group_name = "service-infrastructure-rg"
      location            = "westeurope"
      account_replication_type = "LRS"
       tags = {
        service = "service_name"
      }
    }
  }
  storage_container = {
    terraform = {
      storage_account_name = module.storage.storage_account.mgmt.name
      tags = {
        service = "service_name"
      }
    }
  }
}
