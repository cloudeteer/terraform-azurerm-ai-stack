resource "azurerm_search_service" "this" {
  name                = "srch-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  local_authentication_enabled = var.local_authentication_enabled
  authentication_failure_mode  = var.local_authentication_enabled ? "http401WithBearerChallenge" : null
  sku                          = "standard"

  public_network_access_enabled = true
  allowed_ips                   = var.allowed_ips
  network_rule_bypass_option    = length(var.allowed_ips) > 0 ? "AzureServices" : "None"

  identity {
    type = "SystemAssigned"
  }
}

resource "azapi_resource" "ai_services_connection_search_service" {
  type      = "Microsoft.MachineLearningServices/workspaces/connections@2024-10-01-preview"
  name      = azurerm_search_service.this.name
  parent_id = var.hub_id

  body = {
    properties = {
      category      = "CognitiveSearch",
      target        = "https://${azurerm_search_service.this.name}.search.windows.net/",
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

resource "azapi_resource" "search_service_outbound_rule_hub" {
  type      = "Microsoft.MachineLearningServices/workspaces/outboundRules@2024-10-01-preview"
  name      = "pe-${azurerm_search_service.this.name}"
  parent_id = var.hub_id

  body = {
    properties = {
      type = "PrivateEndpoint"
      destination = {
        serviceResourceId = azurerm_search_service.this.id
        subresourceTarget = "searchService"
      }
    }
  }
}

resource "azurerm_role_assignment" "search_service_ai_developer" {
  for_each = var.create_rbac ? toset([
    "Search Index Data Contributor",
    "Search Service Contributor"
  ]) : []

  scope                = azurerm_search_service.this.id
  role_definition_name = each.value
  principal_id         = var.ai_developer_principal_id
}

resource "azurerm_role_assignment" "search_service_ai_service" {
  for_each = var.create_rbac ? toset([
    "Search Index Data Reader",
    "Search Service Contributor"
  ]) : []

  scope                = azurerm_search_service.this.id
  role_definition_name = each.value
  principal_id         = azurerm_ai_services.this.identity[0].principal_id
}

resource "azurerm_role_assignment" "storage_account_search_service" {
  for_each = var.create_rbac ? toset([
    "Storage Blob Data Reader",
  ]) : []

  principal_id         = azurerm_search_service.this.identity[0].principal_id
  role_definition_name = each.value
  scope                = var.storage_account_id
}
