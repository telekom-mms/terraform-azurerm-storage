module "storage" {
  source              = "../terraform-storage"
  location            = "westeurope"
  resource_group_name = "service-infrastructure-rg"
  resource_name = {
    storage_account = {
      mgmt = "servicemgmtstg"
    }
  }
  storage_account = {
    account_replication_type = "LRS"
  }
  storage_container = {
    terraform = {}
  }
  tags = {
    service = "service_name"
  }
}
