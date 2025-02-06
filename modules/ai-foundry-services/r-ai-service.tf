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

resource "azapi_resource" "ai_services_connection" {
  type      = "Microsoft.MachineLearningServices/workspaces/connections@2024-04-01-preview"
  name      = "aisc-${var.name}"
  parent_id = var.hub_id

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
