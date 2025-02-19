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

  local_authentication_enabled = var.local_authentication_enabled

  public_network_access              = "Enabled" # Allow Selected Networks and Private Endpoints
  outbound_network_access_restricted = true

  network_acls {
    default_action = length(var.allowed_ips) > 0 ? "Deny" : "Allow"
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
  ]) : []

  principal_id         = var.ai_developer_principal_id
  role_definition_name = each.value
  scope                = azurerm_ai_services.this.id
}

resource "azurerm_role_assignment" "ai_service_developer_user_access_administrator" {
  count = var.create_rbac ? 1 : 0

  description          = "This role assignment is needed to deploy web apps from ai.azure.com"
  principal_id         = var.ai_developer_principal_id
  role_definition_name = "User Access Administrator"
  scope                = azurerm_ai_services.this.id

  condition_version = "2.0"
  condition         = <<-CONDITION
    (
        (
          !(ActionMatches{'Microsoft.Authorization/roleAssignments/write'})
        )
        OR
        (
          @Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {5e0bd9bd-7b93-4f28-af87-19fc36ad61bd}
        )
    )
    AND
    (
        (
          !(ActionMatches{'Microsoft.Authorization/roleAssignments/delete'})
        )
        OR
        (
          @Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {5e0bd9bd-7b93-4f28-af87-19fc36ad61bd}
        )
    )
  CONDITION
}

moved {
  from = azurerm_role_assignment.ai_service_developer["User Access Administrator"]
  to   = azurerm_role_assignment.ai_service_developer_user_access_administrator[0]
}

resource "azurerm_role_assignment" "ai_service_search_service" {
  for_each = var.create_rbac ? toset([
    "Cognitive Services OpenAI Contributor",
  ]) : []

  principal_id         = azurerm_search_service.this.identity[0].principal_id
  role_definition_name = each.value
  scope                = azurerm_ai_services.this.id
}

resource "azurerm_role_assignment" "storage_account_ai_service" {
  for_each = var.create_rbac ? toset([
    "Storage Blob Data Contributor",
  ]) : []

  principal_id         = azurerm_ai_services.this.identity[0].principal_id
  role_definition_name = each.value
  scope                = var.storage_account_id
}
