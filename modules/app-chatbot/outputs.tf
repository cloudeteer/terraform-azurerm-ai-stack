output "api_container_app_id" {
  description = "The Azure Container App ID of the API."
  value       = azurerm_container_app.api.id
}

output "api_identity" {
  description = <<-DESCRIPTION
    The user assigned identity used by the API container app.

    Attributes:

    Attribute | Description
    -- | --
    `id` | The ID of the User Assigned Identity.
    `client_id` | The ID of the app associated with the Identity.
    `principal_id` | The ID of the Service Principal object associated with the created Identity.
    `tenant_id` | The ID of the Tenant which the Identity belongs to.
  DESCRIPTION

  value = {
    client_id    = azurerm_user_assigned_identity.api.client_id
    id           = azurerm_user_assigned_identity.api.id
    principal_id = azurerm_user_assigned_identity.api.principal_id
    tenant_id    = azurerm_user_assigned_identity.api.tenant_id
  }
}

output "ui_container_app_id" {
  description = "The Azure Container App ID of the UI."
  value       = azurerm_container_app.ui.id
}

output "ui_identity" {
  description = <<-DESCRIPTION
    The user assigned identity used by the UI container app.

    Attributes:

    Attribute | Description
    -- | --
    `id` | The ID of the User Assigned Identity.
    `client_id` | The ID of the app associated with the Identity.
    `principal_id` | The ID of the Service Principal object associated with the created Identity.
    `tenant_id` | The ID of the Tenant which the Identity belongs to.
  DESCRIPTION

  value = {
    client_id    = azurerm_user_assigned_identity.ui.client_id
    id           = azurerm_user_assigned_identity.ui.id
    principal_id = azurerm_user_assigned_identity.ui.principal_id
    tenant_id    = azurerm_user_assigned_identity.ui.tenant_id
  }
}
