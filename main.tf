// STORAGE ACCOUNT
resource "azurerm_storage_account" "this" {
  name                            = "st${replace(var.name, "-", "")}"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  account_tier                    = "Standard"
  account_replication_type        = "GRS"
  allow_nested_items_to_be_public = false
}

// KEY VAULT
#trivy:ignore:avd-azu-0013
#trivy:ignore:avd-azu-0016
resource "azurerm_key_vault" "this" {
  name                     = "kv${replace(var.name, "-", "")}"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  sku_name                 = "standard"
  purge_protection_enabled = false
}

resource "azurerm_ai_services" "this" {
  name                = "ais-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name              = var.sku
  custom_subdomain_name = var.name

  identity {
    type = "SystemAssigned"
  }
}

// Azure AI Hub
resource "azapi_resource" "hub" {
  type      = "Microsoft.MachineLearningServices/workspaces@2024-04-01-preview"
  name      = "hub-${var.name}"
  location  = var.location
  parent_id = data.azurerm_resource_group.current.id

  identity {
    type = "SystemAssigned"
  }

  body = {
    properties = {
      description    = var.workspace_description
      friendlyName   = coalesce(var.workspace_friendly_name, "AI Hub")
      storageAccount = azurerm_storage_account.this.id
      keyVault       = azurerm_key_vault.this.id

      /* Optional: To enable these field, the corresponding dependent resources need to be uncommented.
      applicationInsight = azurerm_application_insights.this.id
      containerRegistry = azurerm_container_registry.this.id
      */

      /*Optional: To enable Customer Managed Keys, the corresponding
      encryption = {
        status = var.encryption_status
        keyVaultProperties = {
            keyVaultArmId = azurerm_key_vault.this.id
            keyIdentifier = var.cmk_keyvault_key_uri
        }
      }
      */

    }
    kind = "Hub"
  }

  lifecycle {
    ignore_changes = [
      tags # tags are occasionally added by Azure
    ]
  }
}

// Azure AI Project
resource "azapi_resource" "project" {
  type      = "Microsoft.MachineLearningServices/workspaces@2024-04-01-preview"
  name      = "proj-${var.name}"
  location  = var.location
  parent_id = data.azurerm_resource_group.current.id

  identity {
    type = "SystemAssigned"
  }

  body = {
    properties = {
      description   = var.workspace_description
      friendlyName  = coalesce(var.workspace_friendly_name, "AI Project")
      hubResourceId = azapi_resource.hub.id
    }
    kind = "Project"
  }
}

// AzAPI AI Services Connection
resource "azapi_resource" "AIServicesConnection" {
  type      = "Microsoft.MachineLearningServices/workspaces/connections@2024-04-01-preview"
  name      = "aisc-${var.name}"
  parent_id = azapi_resource.hub.id

  body = {
    properties = {
      category      = "AIServices",
      target        = azurerm_ai_services.this.endpoint,
      authType      = "AAD",
      isSharedToAll = true,
      metadata = {
        ApiType    = "Azure",
        ResourceId = azurerm_ai_services.this.id
      }
    }
  }
  response_export_values = ["*"]
}

/* The following resources are OPTIONAL.
// APPLICATION INSIGHTS
resource "azurerm_application_insights" "this" {
  name                = "appi-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
}

// CONTAINER REGISTRY
resource "azurerm_container_registry" "this" {
  name                     = "cr-${var.name}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  sku                      = "premium"
  admin_enabled            = true
}
*/
