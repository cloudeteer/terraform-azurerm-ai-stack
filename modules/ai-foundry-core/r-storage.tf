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

#trivy:ignore:avd-azu-0010
#trivy:ignore:avd-azu-0012
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
    bypass         = [length(var.allowed_ips) > 0 ? "AzureServices" : "None"]
    default_action = length(var.allowed_ips) > 0 ? "Deny" : "Allow"
    ip_rules       = var.allowed_ips
  }
}

resource "azurerm_role_assignment" "storage_account_ai_developer" {
  for_each = var.create_rbac ? toset([
    "Storage Blob Data Contributor",
    "Storage File Data Privileged Contributor",
  ]) : []

  principal_id         = var.ai_developer_principal_id
  role_definition_name = each.value
  scope                = azurerm_storage_account.this.id
}
