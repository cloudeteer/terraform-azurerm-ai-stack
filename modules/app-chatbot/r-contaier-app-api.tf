locals {
  api_env_defaults = {
    ENV = "production"
  }

  api_envs = {
    for key, value in merge(local.api_env_defaults, var.api.envs) : key => value
    if !issensitive(value)
  }

  api_sensitive_envs = {
    for key, value in merge(local.api_env_defaults, var.api.envs) : key => value
    if issensitive(value)
  }
}

resource "azurerm_container_app" "api" {
  name                         = coalesce(var.names.container_app_api, "ca-${var.basename}-api")
  container_app_environment_id = azurerm_container_app_environment.this.id
  resource_group_name          = azurerm_container_app_environment.this.resource_group_name
  revision_mode                = "Single"
  workload_profile_name        = "Consumption"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.api.id]
  }

  ingress {
    external_enabled = false
    target_port      = 8000
    transport        = "auto"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  template {
    max_replicas = 1
    min_replicas = 1

    container {
      name = "api"

      cpu    = var.api.cpu
      memory = var.api.memory
      image  = var.api.container_image

      dynamic "env" {
        for_each = local.api_envs

        content {
          name  = env.key
          value = env.value
        }
      }

      dynamic "env" {
        for_each = keys(local.api_sensitive_envs)

        content {
          name        = env.value
          secret_name = replace(lower(env.value), "_", "-")
        }
      }
    }
  }

  dynamic "registry" {
    for_each = var.container_registry != null ? [true] : []

    content {
      identity = coalesce(var.container_registry.identity, azurerm_user_assigned_identity.api.id)
      server   = var.container_registry.server
    }
  }

  dynamic "secret" {
    for_each = local.api_sensitive_envs

    content {
      name  = replace(lower(secret.key), "_", "-")
      value = sensitive(secret.value)
    }
  }

  depends_on = [azurerm_role_assignment.api]
}
