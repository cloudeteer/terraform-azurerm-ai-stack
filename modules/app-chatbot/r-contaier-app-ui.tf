locals {
  # LibreChat Environment Variables
  # https://www.librechat.ai/docs/configuration/dotenv
  #
  # Default environment variables for LibreChat.
  # These provide baseline configuration values for the LibreChat container app.
  # Any value here can be overridden by specifying the same key in var.ui_envs.
  ui_envs_default = {

    # Azure SDK authentication: User Assigned Identity client and tenant IDs.
    AZURE_CLIENT_ID = azurerm_user_assigned_identity.ui.client_id
    AZURE_TENANT_ID = azurerm_user_assigned_identity.ui.tenant_id

    # Credentials Configuration
    # https://www.librechat.ai/docs/configuration/dotenv#credentials-configuration
    CREDS_IV  = random_bytes.creds_iv.hex
    CREDS_KEY = random_bytes.creds_key.hex

    # MongoDB Database
    # https://www.librechat.ai/docs/configuration/dotenv#mongodb-database
    MONGO_URI = format("%sLibreChat?%s",
      local.mongo_cluser_connection_string_baseurl,
      local.mongo_cluser_connection_string_query,
    )

    # Endpoints
    # https://www.librechat.ai/docs/configuration/dotenv#endpoints
    # ENDPOINTS=openAI,agents,assistants,gptPlugins,azureOpenAI,google,anthropic,bingAI,custom

    # Registration and Login
    # https://www.librechat.ai/docs/configuration/dotenv#registration-and-login
    ALLOW_ACCOUNT_DELETION       = "false"
    ALLOW_EMAIL_LOGIN            = var.entra_id_auth == null
    ALLOW_PASSWORD_RESET         = "false"
    ALLOW_REGISTRATION           = "false"
    ALLOW_SOCIAL_LOGIN           = "false"
    ALLOW_SOCIAL_REGISTRATION    = "false"
    ALLOW_UNVERIFIED_EMAIL_LOGIN = "false"
    JWT_REFRESH_SECRET           = random_bytes.jwt_refresh_secret.hex
    JWT_SECRET                   = random_bytes.jwt_secret.hex

    # Logging
    # https://www.librechat.ai/docs/configuration/dotenv#logging
    DEBUG_LOGGING              = "false"
    DEBUG_CONSOLE              = "false"
    CONSOLE_JSON               = "false"
    CONSOLE_JSON_STRING_LENGTH = "255"

    # Application Domains
    # https://www.librechat.ai/docs/configuration/dotenv#application-domains
    DOMAIN_CLIENT = var.ui.custom_domain_name == null ? null : "https://${var.ui.custom_domain_name}"
    DOMAIN_SERVER = var.ui.custom_domain_name == null ? null : "https://${var.ui.custom_domain_name}"

    # CDN
    # https://www.librechat.ai/docs/configuration/cdn/azure
    # AZURE_CLIENT_ID must be set when using a user-assigned managed identity (configured above)
    AZURE_STORAGE_ACCOUNT_NAME  = azurerm_storage_account.this.name
    AZURE_STORAGE_PUBLIC_ACCESS = "true"
    AZURE_CONTAINER_NAME        = azurerm_storage_container.chatbot_storage.name

    # Other, partly undocumented environment variables
    ALLOW_SHARED_LINKS_PUBLIC = "false"
    CUSTOM_FOOTER             = ""
    SHOW_BIRTHDAY_ICON        = "false"

    # ** Custom Environment Variables **
    # These environment variables are defined and used in librechat.yaml configuration file
    # AZURE_OPENAI_API_KEY = var.azure_openai_api_key
    FASTAPI_INSTANCE_NAME = azurerm_container_app.api.name
  }

  ui_envs_openid_auth = var.entra_id_auth == null ? null : {
    # Application Domains
    # https://www.librechat.ai/docs/configuration/dotenv#application-domains
    ALLOW_SOCIAL_LOGIN = "true" # Required for OpenID Authentication

    # Authentication / OAuth2-OIDC / Azure
    # https://www.librechat.ai/docs/configuration/authentication/OAuth2-OIDC/azure
    OPENID_ISSUER         = "https://login.microsoftonline.com/${var.entra_id_auth.tenant_id}/v2.0/"
    OPENID_CLIENT_ID      = var.entra_id_auth.client_id
    OPENID_CLIENT_SECRET  = var.entra_id_auth.client_secret
    OPENID_SESSION_SECRET = random_bytes.openid_session_secret.hex
    OPENID_CALLBACK_URL   = "/oauth/openid/callback"
    OPENID_SCOPE          = "openid profile email"

    OPENID_REQUIRED_ROLE_TOKEN_KIND = "id"
    # OPENID_REQUIRED_ROLE_PARAMETER_PATH = "roles"
    # OPENID_REQUIRED_ROLE                = "Entra ID Group"

    OPENID_AUTO_REDIRECT            = "true"
    OPENID_USE_END_SESSION_ENDPOINT = "true"

    OPENID_BUTTON_LABEL = "Microsoft Login"
    OPENID_IMAGE_URL    = "https://id-frontend.prod-east.frontend.public.atl-paas.net/assets/microsoft-logo.c73d8dca.svg"
  }

  # Map of all non-sensitive environment variables for LibreChat.
  # Merges local.ui_envs_default with var.ui_envs, where values in var.ui_envs override defaults.
  # Sensitive values are excluded and handled separately as secrets.
  ui_envs = {
    for key, value in merge(
      local.ui_envs_default,
      local.ui_envs_openid_auth,
      var.ui.envs,
    ) : key => value
    if !issensitive(value)
  }

  # Map of all sensitive environment variables for LibreChat.
  # Merges local.ui_envs_default with var.ui_envs, where values in var.ui_envs override defaults.
  # These values are handled as secrets in the container app configuration.
  ui_envs_sensitive = {
    for key, value in merge(
      local.ui_envs_default,
      local.ui_envs_openid_auth,
      var.ui.envs,
    ) : key => value
    if issensitive(value)
  }
}

resource "azurerm_container_app" "ui" {
  name                         = coalesce(var.names.container_app_ui, "ca-${var.basename}-ui")
  container_app_environment_id = azurerm_container_app_environment.this.id
  resource_group_name          = azurerm_container_app_environment.this.resource_group_name
  revision_mode                = "Single"
  workload_profile_name        = "Consumption"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.ui.id]
  }

  ingress {
    external_enabled = true
    target_port      = 3080
    transport        = "auto"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  template {
    max_replicas = 1
    min_replicas = 0

    container {
      name = "ui"

      cpu    = var.ui.cpu
      memory = var.ui.memory
      image  = var.ui.container_image

      dynamic "env" {
        for_each = local.ui_envs

        content {
          name  = env.key
          value = env.value
        }
      }

      dynamic "env" {
        for_each = keys(local.ui_envs_sensitive)

        content {
          name        = env.value
          secret_name = replace(lower(env.value), "_", "-")
        }
      }

      dynamic "env" {
        for_each = length(local.ui_envs_sensitive) == 0 ? [] : [true]
        content {
          name  = "container_apps_secrets_hash"
          value = sha256(join("", values(local.ui_envs_sensitive)))
        }
      }
    }
  }

  dynamic "registry" {
    for_each = var.container_registry != null ? [true] : []

    content {
      identity = coalesce(var.container_registry.identity, azurerm_user_assigned_identity.ui.id)
      server   = var.container_registry.server
    }
  }

  dynamic "secret" {
    for_each = local.ui_envs_sensitive

    content {
      name  = replace(lower(secret.key), "_", "-")
      value = sensitive(secret.value)
    }
  }

  depends_on = [
    azurerm_role_assignment.ui
  ]
}

resource "random_bytes" "creds_key" {
  length = 32
}

resource "random_bytes" "creds_iv" {
  length = 16
}

resource "random_bytes" "jwt_secret" {
  length = 64
}

resource "random_bytes" "jwt_refresh_secret" {
  length = 64
}
moved {
  from = random_bytes.JWT_REFRESH_SECRET
  to   = random_bytes.jwt_refresh_secret
}

resource "random_bytes" "openid_session_secret" {
  length = 16
}
