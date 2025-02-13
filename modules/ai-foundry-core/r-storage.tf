locals {
  storage_account_name = format(
    "st%s%s",
    lower(
      substr(
        replace(var.name, "-", ""), 0, 24 - 2 - local.random_string_length
      )
    ),
    random_string.suffix.result
  )
}

resource "azurerm_storage_account" "this" {
  name                = local.storage_account_name
  location            = var.location
  resource_group_name = var.resource_group_name

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "ZRS"
  access_tier              = "Hot"

  allow_nested_items_to_be_public   = false
  cross_tenant_replication_enabled  = false
  default_to_oauth_authentication   = true
  https_traffic_only_enabled        = true
  infrastructure_encryption_enabled = true
  is_hns_enabled                    = false
  large_file_share_enabled          = false
  min_tls_version                   = "TLS1_2"
  public_network_access_enabled     = var.public_network_access
  shared_access_key_enabled         = false # ** NOTE: This requires storage_use_azuread to be set in provider config

  network_rules {
    bypass         = ["AzureServices"]
    default_action = "Deny"
    ip_rules       = var.allowed_ips
  }
}
