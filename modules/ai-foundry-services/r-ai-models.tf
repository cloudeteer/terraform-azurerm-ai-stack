resource "azurerm_cognitive_deployment" "this" {
  for_each = { for model in var.models : coalesce(model.deployment_name, model.name) => model }

  name = coalesce(each.value.deployment_name, each.value.name)

  cognitive_account_id = azurerm_ai_services.this.id
  rai_policy_name      = "Microsoft.DefaultV2"

  model {
    format  = each.value.format
    name    = each.value.name
    version = each.value.version
  }

  sku {
    name     = each.value.sku_name
    capacity = each.value.sku_capacity
  }
}
