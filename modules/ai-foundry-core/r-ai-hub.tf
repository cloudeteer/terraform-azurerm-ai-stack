resource "azurerm_resource_group" "developer" {
  name     = format("rg-%s_developer", var.basename)
  location = var.location
}

resource "azurerm_role_assignment" "rg_developer_ai_developer" {
  for_each = var.create_rbac ? toset([
    "Contributor",
  ]) : []

  principal_id         = var.ai_developer_principal_id
  role_definition_name = each.value
  scope                = azurerm_resource_group.developer.id
}

resource "azapi_resource" "hub" {
  type      = "Microsoft.MachineLearningServices/workspaces@2024-10-01-preview"
  name      = "hub-${var.basename}"
  location  = var.location
  parent_id = var.resource_group_id

  identity {
    type = "SystemAssigned"
  }

  body = {
    properties = {
      description  = var.description
      friendlyName = coalesce(var.friendly_name, "AI Hub")

      workspaceHubConfig = {
        defaultWorkspaceResourceGroup = azurerm_resource_group.developer.id
      }

      storageAccount = azurerm_storage_account.this.id
      keyVault       = azurerm_key_vault.this.id

      provisionNetworkNow      = true
      publicNetworkAccess      = var.public_network_access ? "Enabled" : "Disabled"
      systemDatastoresAuthMode = "identity"

      managedNetwork = {
        # ** NOTE **
        # If you use any other option here, you have to create the private endpoints (on outboundRules below)
        # to private storage account and key vault by yourself. Using AllowOnlyApprovedOutbound creates those
        # private endpoints as required outbound rule in the managed virtual network automatically.
        isolationMode = var.hub_network_config.isolation_mode
        outboundRules = {}
      }
    }
    kind = "Hub"
  }

  lifecycle {
    ignore_changes = [
      tags # tags are occasionally added by Azure
    ]
  }
}

resource "azurerm_role_assignment" "hub_ai_developer" {
  for_each = var.create_rbac ? toset([
    "Azure AI Developer",
  ]) : []

  principal_id         = var.ai_developer_principal_id
  role_definition_name = each.value
  scope                = azapi_resource.hub.output.id
}
