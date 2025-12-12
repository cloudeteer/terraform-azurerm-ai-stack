variable "ai_developer_principal_id" {
  type = string

  description = <<-DESCRIPTION
    The principal ID of a user or group of AI Developers who will have access to this AI Foundry Hub.

    The following roles will be assigned to the given principal ID:

    | Role | Scope |
    | -- | -- |
    | Azure AI Developer | AI Foundry Hub |
    | Azure AI Developer | AI Foundry Project |
    | Contributor | Developer Resource Group |
    | Storage Blob Data Contributor | Storage Account |
    | Storage File Data Privileged Contributor | Storage Account |
    | Cognitive Services Contributor | AI Service |
    | Cognitive Services OpenAI Contributor | AI Service |
    | Cognitive Services User | AI Service |
    | User Access Administrator | AI Service |
    | Search Index Data Contributor | AI Search Service |
    | Search Service Contributor | AI Search Service |

    Argument | Description
    -- | --
    `isolation_mode` | Isolation mode for the managed network of a machine learning workspace. Possible values are `AllowOnlyApprovedOutbound`, `AllowInternetOutbound`, or `Disabled`.
    `public_network_access` | Whether requests from Public Network are allowed.

    **NOTE**: The `User Access Administrator` role is assigned with the condition that only the `Cognitive Services OpenAI User` role can be assigned to user principals. This is necessary to successfully deploy a Web App on top of an AI Model through the AI Foundry Hub.
  DESCRIPTION

  default = null
}

variable "allowed_ips" {
  type        = list(string)
  description = "List of IP addresses to allow access to the Azure AI service."
  default     = []
  nullable    = false
}

variable "basename" {
  type        = string
  description = "The basename of all resources deployed by this module. Please use only 28 characters or less."

  # 28 characters because "azapi_resource" "search_service_outbound_rule_hub" adds already 3 characters
  validation {
    condition     = length(var.basename) < 29
    error_message = "Your 'basename' is too long, please chose a shoter name."
  }
}

variable "chatbot" {
  description = <<-DESCRIPTION
    Configuration options for deploying the chatbot submodule as part of the AI Foundry Hub. This variable allows you to enable or disable chatbot, customize its deployment, specify container images, environment variables, and provide advanced configuration such as custom domains, model selection, and branding.

    Required arguments:

    Argument | Description
    -- | --
    `enabled` | Set to `true` to deploy the chatbot submodule. Defaults to `false`.

    Optional arguments:

    Argument | Description
    -- | --
    `api` | A `api` object for API configuration, as defined below.
    `container_registry` | A `container_registry` object specifying the Azure Container Registry to pull container images from.
    `models` | List of model names to expose in the chatbot frontend. Each model must be deployed via `var.models`.
    `ui` | A `ui` object for UI configuration, as defined below.

    `api` object arguments:

    Argument | Description
    -- | --
    `container_image` | Container image for the chatbot frontend. If omitted, the default image will be used.
    `envs` | Map of environment variables to inject into the chatbot container application.
    `custom_domain_name` | Custom subdomain for the chatbot application. If not specified, a default subdomain in the format `<region>.azurecontainerapps.io` will be used.

    `container_registry` object arguments:

    Argument | Description
    -- | --
    `server` | Hostname of the Azure Container Registry (the `server` output of an `azurerm_container_registry` resource).
    `id` | Resource ID of the Azure Container Registry.
    `create_rbac` | Specifies whether to create role assignments that grant the container app's managed identity permissions to pull images from the container registry. Defaults to `true`.

    `ui` object arguments:

    Argument | Description
    -- | --
    `container_image` | Container image for the chatbot frontend. If omitted, the default image will be used.
    `envs` | Map of environment variables to inject into the chatbot container application.
    `custom_domain_name` | Custom subdomain for the chatbot application. If not specified, a default subdomain in the format `<region>.azurecontainerapps.io` will be used.
  DESCRIPTION

  type = object({
    enabled = bool
    models  = optional(list(string))

    api = optional(object({
      container_image    = optional(string)
      envs               = optional(map(string), {})
      custom_domain_name = optional(string)
    }), {})

    container_registry = optional(object({
      server      = string
      id          = string
      create_rbac = optional(bool, true)
    }))

    entra_id_auth = optional(object({
      tenant_id     = string
      client_id     = string
      client_secret = string
    }))

    ui = optional(object({
      container_image    = optional(string)
      envs               = optional(map(string), {})
      custom_domain_name = optional(string)
    }), {})
  })

  default = { enabled = false }
}

variable "create_rbac" {
  type = bool

  description = <<-DESCRIPTION
    If set to `true` (default), the following mandatory Azure role assignments will be created:

    | Role | Scope | Principal |
    | -- | -- | -- |
    | Cognitive Services OpenAI Contributor | AI Service | AI Search Service Identity |
    | Search Index Data Reader | AI Search Service | AI Service Identity |
    | Search Service Contributor | AI Search Service | AI Service Identity |
    | Storage Blob Data Contributor | Storage Account | AI Service Identity |
    | Storage Blob Data Reader | Storage Account | AI Search Service Identity |

    **NOTE**: If set to `false`, these role assignments must be created manually to ensure the AI Foundry Hub Project functions correctly.
  DESCRIPTION

  default  = true
  nullable = false
}

variable "description" {
  type        = string
  description = "The description of this workspace."
  default     = null
}

variable "friendly_name" {
  type        = string
  description = "The friendly name for this workspace. This value in mutable."
  default     = null
}

variable "hub_network_config" {
  type = object({
    isolation_mode        = optional(string, "AllowOnlyApprovedOutbound")
    public_network_access = optional(bool, false)
  })

  description = <<-DESCRIPTION
    Network configuration for the AI Hub.

    Optional arguments:

    Argument | Description
    -- | --
    `isolation_mode` | Isolation mode for the managed network of a machine learning workspace. Possible values are `AllowOnlyApprovedOutbound`, `AllowInternetOutbound`, or `Disabled`.
    `public_network_access` | Whether requests from Public Network are allowed.

    **NOTE**:
  DESCRIPTION

  default  = {}
  nullable = false
}

variable "local_authentication_enabled" {
  type        = bool
  description = "Specifies whether the services allows authentication using local API keys."
  default     = true
  nullable    = false
}

variable "location" {
  type        = string
  description = "Location of the resource group."
  default     = "swedencentral"
  nullable    = false
}

variable "models" {
  type = list(object({
    name            = string
    deployment_name = optional(string)
    format          = optional(string)
    sku_capacity    = optional(number)
    sku_name        = optional(string)
    version         = optional(string)
  }))

  description = <<-DESCRIPTION
    A list of models to deploy to the workspace.

    Required parameters:

    Parameter | Description
    -- | --
    `name` | The name of the Cognitive Services Account Deployment model. Changing this forces a new resource to be created.

    Optional parameters:

    Parameter | Description
    -- | --
    `deployment_name` | The name to assign to the model deployment. If not specified, the value of `name` will be used by default. This property allows you to customize the deployment resource name independently from the model name.
    `format` | The format of the Cognitive Services Account Deployment model. Changing this forces a new resource to be created. Possible value is `OpenAI`.
    `sku_capacity` | Tokens-per-Minute (TPM). The unit of measure for this field is in the thousands of Tokens-per-Minute. Defaults to `1` which means that the limitation is `1000` tokens per minute. If the resources SKU supports scale in/out then the capacity field should be included in the resources' configuration. If the scale in/out is not supported by the resources SKU then this field can be safely omitted. For more information about TPM please see the [product documentation](https://learn.microsoft.com/azure/ai-services/openai/how-to/quota?tabs=rest).
    `sku_name` | The name of the SKU. Possible values include `Standard`, `DataZoneStandard`, `DataZoneProvisionedManaged`, `GlobalBatch`, `GlobalProvisionedManaged`, `GlobalStandard`, and `ProvisionedManaged`.
    `version` | The version of Cognitive Services Account Deployment model. If `version` is not specified, the default version of the model at the time will be assigned.

    **Note**: `DataZoneProvisionedManaged`, `GlobalProvisionedManaged`, and `ProvisionedManaged` are purchased on-demand at an hourly basis based on the number of deployed PTUs, with substantial term discount available via the purchase of Azure Reservations. Currently, this step cannot be completed using Terraform. For more details, please refer to the [provisioned throughput onboarding documentation](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/provisioned-throughput-onboarding).
  DESCRIPTION

  default  = []
  nullable = false
}

variable "names" {
  description = "Allow overwrite the names of specific resources, instead of using generated names by this module bases on `var.basename`. This can be handy when importing existing resources which name should not change, or when having custom naming convetions this module does not consider."

  type = object({
    chatbot_container_app_ui  = optional(string)
    chatbot_container_app_api = optional(string)
  })

  default = {}
}

variable "public_network_access" {
  type        = bool
  description = "Allow Public Access on AI Services, Storage Account, Key Vault, etc."
  default     = false
  nullable    = false
}

variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
}

variable "search_service_sku" {
  type        = string
  description = "The SKU which should be used for this Search Service. Possible values include basic, free, standard, standard2, standard3, storage_optimized_l1 and storage_optimized_l2. Changing this forces a new Search Service to be created. Some SKU´s may with some restrictions. See https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/search_service#sku-1"
  default     = "standard"
}

variable "sku" {
  type        = string
  description = "The sku name of the Azure Analysis Services server to create. Choose from: B1, B2, D1, S0, S1, S2, S3, S4, S8, S9. Some skus are region specific. See https://docs.microsoft.com/en-us/azure/analysis-services/analysis-services-overview#availability-by-region"
  default     = "S0"
  nullable    = false
}
