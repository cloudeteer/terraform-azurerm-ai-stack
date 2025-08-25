resource "azurerm_user_assigned_identity" "api" {
  name                = "id-${var.basename}-api"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_user_assigned_identity" "ui" {
  name                = "id-${var.basename}-ui"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "api" {
  for_each = var.container_registry == null ? {} : { for _ in [
    {
      name                 = "acr-pull"
      role_definition_name = "AcrPull"
      scope                = var.container_registry.id
    }
  ] : _.name => _ }

  role_definition_name = each.value.role_definition_name
  scope                = each.value.scope

  principal_id = azurerm_user_assigned_identity.api.principal_id
}

resource "azurerm_role_assignment" "ui" {
  for_each = var.container_registry == null ? {} : { for _ in [
    {
      name                 = "acr-pull"
      role_definition_name = "AcrPull"
      scope                = var.container_registry.id
    }
  ] : _.name => _ }

  role_definition_name = each.value.role_definition_name
  scope                = each.value.scope

  principal_id = azurerm_user_assigned_identity.ui.principal_id
}
