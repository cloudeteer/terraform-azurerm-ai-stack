module "ai_foundry_core" {
  source = "cloudeteer/ai-stack/azurerm//modules/ai-foundry-core"

  name                = var.basename
  location            = var.location
  resource_group_id   = local.resource_group_id
  resource_group_name = var.resource_group_name
}
