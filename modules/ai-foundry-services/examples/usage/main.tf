module "ai_foundry_services" {
  source = "cloudeteer/azure-ai-foundry-hub/azurerm//modules/ai-foundry-services"

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku    = var.sku
  hub_id = module.ai_foundry_core.hub_id
}
