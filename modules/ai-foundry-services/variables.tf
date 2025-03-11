variable "ai_developer_principal_id" {
  type        = string
  default     = null
  description = "The principal ID of a user or group of AI Developers who will have access to this AI Foundry Hub."
}

variable "allowed_ips" {
  type        = list(string)
  description = "List of IP addresses to allow access to the service."
  default     = []
  nullable    = false
}

variable "create_rbac" {
  type        = bool
  description = "Create Aure Role Assignments and grant all needed permissions to the `principal_id`."
  default     = false
  nullable    = false
}

variable "hub_id" {
  type        = string
  description = "The ID of the Azure AI hub."
}

variable "local_authentication_enabled" {
  type        = bool
  description = "Specifies whether the services allows authentication using local API keys."
  default     = false
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
    name         = string
    format       = optional(string)
    sku_capacity = optional(number)
    sku_name     = optional(string)
    version      = optional(string)
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
    `format` | The format of the Cognitive Services Account Deployment model. Changing this forces a new resource to be created. Possible value is `OpenAI`.
    `sku_capacity` | Tokens-per-Minute (TPM). The unit of measure for this field is in the thousands of Tokens-per-Minute. Defaults to `1` which means that the limitation is `1000` tokens per minute. If the resources SKU supports scale in/out then the capacity field should be included in the resources' configuration. If the scale in/out is not supported by the resources SKU then this field can be safely omitted. For more information about TPM please see the [product documentation](https://learn.microsoft.com/azure/ai-services/openai/how-to/quota?tabs=rest).
    `sku_name` | The name of the SKU. Possible values include `Standard`, `DataZoneStandard`, `DataZoneProvisionedManaged`, `GlobalBatch`, `GlobalProvisionedManaged`, `GlobalStandard`, and `ProvisionedManaged`.
    `version` | The version of Cognitive Services Account Deployment model. If `version` is not specified, the default version of the model at the time will be assigned.

    **Note**: `DataZoneProvisionedManaged`, `GlobalProvisionedManaged`, and `ProvisionedManaged` are purchased on-demand at an hourly basis based on the number of deployed PTUs, with substantial term discount available via the purchase of Azure Reservations. Currently, this step cannot be completed using Terraform. For more details, please refer to the [provisioned throughput onboarding documentation](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/provisioned-throughput-onboarding).
  DESCRIPTION

  default  = []
  nullable = false
}

variable "name" {
  type        = string
  description = "The name of the this resource."
}

variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
}

variable "sku" {
  type        = string
  description = "The sku name of the Azure Analysis Services server to create. Choose from: B1, B2, D1, S0, S1, S2, S3, S4, S8, S9. Some skus are region specific. See https://docs.microsoft.com/en-us/azure/analysis-services/analysis-services-overview#availability-by-region"
  default     = "S0"
  nullable    = false
}

variable "storage_account_id" {
  type        = string
  description = "The ID of the Azure Storage Account."
}
