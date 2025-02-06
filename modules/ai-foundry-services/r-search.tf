resource "azurerm_search_service" "this" {
  name                = "srch-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  local_authentication_enabled = false
  sku                          = "standard"
}

resource "azapi_resource" "ai_services_connection_search_service" {
  type      = "Microsoft.MachineLearningServices/workspaces/connections@2024-10-01-preview"
  name      = azurerm_search_service.this.name
  parent_id = var.hub_id

  body = {
    properties = {
      category      = "CognitiveSearch",
      target        = "https://${azurerm_search_service.this.name}.search.windows.net",
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
