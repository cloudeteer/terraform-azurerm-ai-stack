resource "azapi_resource" "hub" {
  type      = "Microsoft.MachineLearningServices/workspaces@2024-04-01-preview"
  name      = "hub-${var.name}"
  location  = var.location
  parent_id = var.resource_group_id

  identity {
    type = "SystemAssigned"
  }

  body = {
    properties = {
      description    = var.description
      friendlyName   = coalesce(var.friendly_name, "AI Hub")
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
