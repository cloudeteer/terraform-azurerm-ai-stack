locals {
  resource_group_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"
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

module "ai_foundry_core" {
  source = "./modules/ai-foundry-core"

  name                = var.name
  location            = var.location
  resource_group_id   = local.resource_group_id
  resource_group_name = var.resource_group_name

  description   = var.description
  friendly_name = var.friendly_name
}

moved {
  from = azurerm_storage_account.this
  to   = module.ai_foundry_core.azurerm_storage_account.this
}

moved {
  from = azurerm_key_vault.this
  to   = module.ai_foundry_core.azurerm_key_vault.this
}

moved {
  from = azapi_resource.hub
  to   = module.ai_foundry_core.azapi_resource.hub
}

moved {
  from = azapi_resource.project
  to   = module.ai_foundry_core.azapi_resource.project
}


resource "azapi_resource" "ai_services_connection" {
  type      = "Microsoft.MachineLearningServices/workspaces/connections@2024-04-01-preview"
  name      = "aisc-${var.name}"
  parent_id = module.ai_foundry_core.hub_id

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
resource "azurerm_application_insights" "this" {
  name                = "appi-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
}

resource "azurerm_container_registry" "this" {
  name                     = "cr-${var.name}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  sku                      = "premium"
  admin_enabled            = true
}
*/
