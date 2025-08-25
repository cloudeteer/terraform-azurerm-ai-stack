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
  search_service_sku           = var.search_service_sku
  sku                          = var.sku
  storage_account_id           = module.ai_foundry_core.storage_account_id

  # WIP: Fix tear down dependency issue
  depends_on = [module.ai_foundry_core]
}

module "app_chatbot" {
  count  = var.chatbot.enabled ? 1 : 0
  source = "./modules/app-chatbot"

  basename            = var.basename
  location            = var.location
  resource_group_name = var.resource_group_name

  names = {
    container_app_ui  = var.names.chatbot_container_app_ui
    container_app_api = var.names.chatbot_container_app_api
  }

  container_registry = var.chatbot.container_registry
  entra_id_auth      = var.chatbot.entra_id_auth

  api = merge(var.chatbot.api, {

    enabled = true
    envs = merge({
      AZURE_OPENAI_ENDPOINT            = "https://${module.ai_foundry_services.ai_service_custom_subdomain_name}.openai.azure.com/"
      AZURE_OPENAI_API_KEY             = module.ai_foundry_services.ai_service_primary_access_key
      AZURE_AI_SEARCH_SERVICE_ENDPOINT = module.ai_foundry_services.search_service_endpoint
      AZURE_AI_SEARCH_API_KEY          = module.ai_foundry_services.search_service_primary_key
    }, coalesce(var.chatbot.api.envs, {}))
  })

  ui = merge(var.chatbot.ui, {
    enabled = true

    envs = merge({
      # Azure AI Search Plugin configuration
      # Reference: https://www.librechat.ai/docs/configuration/tools/azure_ai_search
      AZURE_AI_SEARCH_SERVICE_ENDPOINT = module.ai_foundry_services.search_service_endpoint
      AZURE_AI_SEARCH_API_KEY          = module.ai_foundry_services.search_service_primary_key

      # LibreChat UI customization
      # Reference: https://www.librechat.ai/docs/configuration/dotenv#app-title-and-footer
      APP_TITLE     = var.friendly_name
      CUSTOM_FOOTER = var.friendly_name

      # Custom variables for librechat.yaml configuration
      # Reference: https://www.librechat.ai/docs/configuration/librechat_yaml
      AZURE_OPENAI_API_KEY       = module.ai_foundry_services.ai_service_primary_access_key
      AZURE_OPENAI_INSTANCE_NAME = module.ai_foundry_services.ai_service_custom_subdomain_name
    }, coalesce(var.chatbot.ui.envs, {}))
  })
}
