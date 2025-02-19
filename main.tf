locals {
  resource_group_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"
}

module "ai_foundry_core" {
  source = "./modules/ai-foundry-core"

  name                = var.name
  location            = var.location
  resource_group_id   = local.resource_group_id
  resource_group_name = var.resource_group_name

  ai_developer_principal_id = var.ai_developer_principal_id
  allowed_ips               = var.allowed_ips
  create_rbac               = var.create_rbac
  description               = var.description
  friendly_name             = var.friendly_name
  hub_network_config        = var.hub_network_config
  public_network_access     = var.public_network_access
}

moved {
  from = azurerm_storage_account.this
  to   = module.ai_foundry_core.azurerm_storage_account.this
}

moved {
  from = azurerm_key_vault.this
  to   = module.ai_foundry_core.azurerm_key_vault.this
}

moved {
  from = azapi_resource.hub
  to   = module.ai_foundry_core.azapi_resource.hub
}

moved {
  from = azapi_resource.project
  to   = module.ai_foundry_core.azapi_resource.project
}

module "ai_foundry_services" {
  source = "./modules/ai-foundry-services"

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  hub_id = module.ai_foundry_core.hub_id

  ai_developer_principal_id    = var.ai_developer_principal_id
  allowed_ips                  = var.allowed_ips
  create_rbac                  = var.create_rbac
  local_authentication_enabled = var.local_authentication_enabled
  models                       = var.models
  sku                          = var.sku
  storage_account_id           = module.ai_foundry_core.storage_account_id
}

moved {
  from = azurerm_search_service.this
  to   = module.ai_foundry_services.azurerm_search_service.this
}

moved {
  from = azapi_resource.ai_services_connection_search_service
  to   = module.ai_foundry_services.azapi_resource.ai_services_connection_search_service
}

moved {
  from = azapi_resource.ai_services_connection
  to   = module.ai_foundry_services.azapi_resource.ai_services_connection
}

moved {
  from = azurerm_ai_services.this
  to   = module.ai_foundry_services.azurerm_ai_services.this
}

moved {
  from = azurerm_cognitive_deployment.this
  to   = module.ai_foundry_services.azurerm_cognitive_deployment.this
}


/* The following resources are OPTIONAL.
resource "azurerm_application_insights" "this" {
  name                = "appi-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
}

resource "azurerm_container_registry" "this" {
  name                     = "cr-${var.name}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  sku                      = "premium"
  admin_enabled            = true
}
*/
