resource "azapi_resource" "hub" {
  type      = "Microsoft.MachineLearningServices/workspaces@2024-10-01-preview"
  name      = "hub-${var.name}"
  location  = var.location
  parent_id = var.resource_group_id

  identity {
    type = "SystemAssigned"
  }

  body = {
    properties = {
      description  = var.description
      friendlyName = coalesce(var.friendly_name, "AI Hub")

      storageAccount = azurerm_storage_account.this.id
      keyVault       = azurerm_key_vault.this.id

      provisionNetworkNow      = true
      publicNetworkAccess      = var.hub_network_config.public_network_access ? "Enabled" : "Disabled"
      systemDatastoresAuthMode = "identity"

      managedNetwork = {
        # ** NOTE ** If you use any other option here, you have to create the private endpoints (on outboundRules below) to private storage account and key vault by yourself. Using AllowOnlyApprovedOutbound creates those private endpoints as required outbound rule in the managed virtual network automatically.
        isolationMode = var.hub_network_config.isolation_mode
        outboundRules = {
          /*search = {
            type = "PrivateEndpoint"
            destination = {
              serviceResourceId = var.search_service_id
              subresourceTarget = "searchService"
              sparkEnabled      = false
              sparkStatus       = "Inactive"
            }
          },
          aiservices = {
            type = "PrivateEndpoint"
            destination = {
              serviceResourceId = var.ai_services_id
              subresourceTarget = "account"
              sparkEnabled      = false
              sparkStatus       = "Inactive"
            }
          },*/
        }
      }

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
