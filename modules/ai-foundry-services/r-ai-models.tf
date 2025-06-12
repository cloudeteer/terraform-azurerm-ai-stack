locals {
  model_defaults = [
    {
      name         = "gpt-4o-mini"
      format       = "OpenAI"
      sku_capacity = 10
      sku_name     = "GlobalStandard"
      version      = "2024-11-20"
    },
    {
      name         = "gpt-4o"
      format       = "OpenAI"
      sku_capacity = 10
      sku_name     = "GlobalStandard"
      version      = "2024-11-20"
    },
  ]

  models = {
    for model in var.models : model.name => one(
      [
        for default in local.model_defaults : {
          name            = model.name
          deployment_name = coalesce(model.deployment_name, model.name)
          format          = coalesce(model.format, default.format)
          sku_capacity    = coalesce(model.sku_capacity, default.sku_capacity)
          sku_name        = coalesce(model.sku_name, default.sku_name)
          version         = coalesce(model.version, default.version)
        } if default.name == model.name
      ]
    )
  }
}

resource "azurerm_cognitive_deployment" "this" {
  for_each = local.models

  name = each.value.deployment_name

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
