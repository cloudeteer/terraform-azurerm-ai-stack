resource "random_string" "identifier" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_ai_services" "this" {
  name                = "ais-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name              = var.sku
  custom_subdomain_name = "${var.name}-${lower(random_string.identifier.result)}"

  local_authentication_enabled = false

  public_network_access              = "Enabled" # Allow Selected Networks and Private Endpoints
  outbound_network_access_restricted = true

  network_acls {
    default_action = "Deny"
    ip_rules       = var.allowed_ips
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azapi_resource" "ai_services_connection" {
  type      = "Microsoft.MachineLearningServices/workspaces/connections@2024-10-01-preview"
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

resource "azapi_resource" "ai_services_outbound_rule_hub" {
  type      = "Microsoft.MachineLearningServices/workspaces/outboundRules@2024-10-01-preview"
  name      = "pe-${azurerm_ai_services.this.name}"
  parent_id = var.hub_id

  body = {
    properties = {
      type = "PrivateEndpoint"
      destination = {
        serviceResourceId = azurerm_ai_services.this.id
        subresourceTarget = "account"
      }
    }
  }
}

resource "azurerm_role_assignment" "ai_service_developer" {
  for_each = var.create_rbac ? toset([
    "Cognitive Services Contributor",
    "Cognitive Services OpenAI Contributor",
    "Cognitive Services User",
    "Role Based Access Control Administrator", # Needed to Deploy Web Apps from WebUI ai.azure.com
  ]) : []

  scope                = azurerm_ai_services.this.id
  role_definition_name = each.value
  principal_id         = var.ai_developer_principal_id
}
