module "storage" {
  source = "registry.terraform.io/T-Systems-MMS/storage/azurerm"
  storage_account = {
    mgmt = {
      name                = "servicemgmtstg"
      resource_group_name = "service-infrastructure-rg"
      location            = "westeurope"
      min_tls_version     = "TLS1_0"
      static_website = {
        error_404_document = "404.html"
        index_document     = "index.html"
      }
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
