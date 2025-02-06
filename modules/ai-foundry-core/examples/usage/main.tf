module "ai_foundry_core" {
  source = "cloudeteer/azure-ai-foundry-hub/azurerm//modules/ai-foundry-core"

  name                = var.name
  location            = var.location
  resource_group_id   = local.resource_group_id
  resource_group_name = var.resource_group_name
}
