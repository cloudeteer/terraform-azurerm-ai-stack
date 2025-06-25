locals {
  storage_account_name = format(
    "st%s%s",
    lower(
      substr(
        replace(var.basename, "-", ""), 0, 24 - 2 - local.random_string_length
      )
    ),
    random_string.suffix.result
  )
}

#trivy:ignore:avd-azu-0010 // Trusted Microsoft Services should have bypass access to Storage accounts
#trivy:ignore:avd-azu-0012 // The default action on Storage account network rules should be set to deny
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

  blob_properties {
    cors_rule {
      allowed_headers = [
        "*",
      ]
      allowed_methods = [
        "GET",
        "HEAD",
        "PUT",
        "DELETE",
        "OPTIONS",
        "POST",
        "PATCH",
      ]
      allowed_origins = [
        "https://mlworkspace.azure.ai",
        "https://ml.azure.com",
        "https://*.ml.azure.com",
        "https://ai.azure.com",
        "https://*.ai.azure.com",
      ]
      exposed_headers = [
        "*",
      ]
      max_age_in_seconds = 1800
    }

    delete_retention_policy {
      days = 7
    }
  }




}

resource "azurerm_role_assignment" "storage_account_ai_developer" {
  for_each = var.ai_developer_principal_id == null ? [] : toset([
    "Storage Blob Data Contributor",
    "Storage File Data Privileged Contributor",
  ])

  principal_id         = var.ai_developer_principal_id
  role_definition_name = each.value
  scope                = azurerm_storage_account.this.id
}
