module "ai_foundry_services" {
  source = "cloudeteer/ai-stack/azurerm//modules/ai-foundry-services"

  name                = var.basename
  location            = var.location
  resource_group_name = var.resource_group_name

  sku    = var.sku
  hub_id = module.ai_foundry_core.hub_id
}
