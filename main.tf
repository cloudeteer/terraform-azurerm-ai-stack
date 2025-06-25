locals {
  resource_group_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"
}

module "ai_foundry_core" {
  source = "./modules/ai-foundry-core"

  basename            = var.basename
  location            = var.location
  resource_group_id   = local.resource_group_id
  resource_group_name = var.resource_group_name

  ai_developer_principal_id = var.ai_developer_principal_id
  allowed_ips               = var.allowed_ips
  description               = var.description
  friendly_name             = var.friendly_name
  hub_network_config        = var.hub_network_config
  public_network_access     = var.public_network_access
}

module "ai_foundry_services" {
  source = "./modules/ai-foundry-services"

  basename            = var.basename
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
