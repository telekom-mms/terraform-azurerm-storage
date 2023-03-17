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
    filestorage = {
      name                      = "servicefilestg"
      resource_group_name       = "service-infrastructure-rg"
      location                  = "westeurope"
      account_kind              = "FileStorage"
      account_tier              = "Premium"
      account_replication_type  = "LRS"
      enable_https_traffic_only = false
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
  storage_share = {
    nfsfiles = {
      storage_account_name = module.storage.storage_account.filestorage.name
      access_tier          = "Premium"
      enabled_protocol     = "NFS"
      quota                = 100
    }
  }
}
