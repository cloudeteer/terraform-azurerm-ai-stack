# variable "cmk_keyvault_key_uri" {
#   type        = string
#   description = "Key vault uri to access the encryption key."
# }

# variable "encryption_status" {
#   type        = string
#   description = "Indicates whether or not the encryption is enabled for the workspace."
#   default     = "Enabled"
# }

variable "location" {
  type        = string
  default     = "eastus"
  description = "Location of the resource group."
}

variable "hub_network_config" {
  type = object({
    isolation_mode        = optional(string, "AllowOnlyApprovedOutbound")
    public_network_access = optional(bool, false)
  })

  default = {}

  description = <<-DESCRIPTION
    Network configuration for the AI Hub.

    Optional arguments:

    Argument | Description
    -- | --
    `isolation_mode` | Isolation mode for the managed network of a machine learning workspace. Possible values are `AllowOnlyApprovedOutbound`, `AllowInternetOutbound`, or `Disabled`.
    `public_network_access` | Whether requests from Public Network are allowed.

    **NOTE**:
  DESCRIPTION
}

variable "models" {
  type = list(object({
    name         = string
    format       = optional(string)
    sku_capacity = optional(number)
    sku_name     = optional(string)
    version      = optional(string)
  }))

  # TODO: Add a description that is more specific to the models variable.
  description = "A map of models to deploy to the workspace."
  default     = []
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
}

variable "description" {
  type        = string
  description = "The description of this workspace."
  default     = ""
}

variable "friendly_name" {
  type        = string
  description = "The friendly name for this workspace. This value in mutable."
  default     = ""
}

variable "ip_rules" {
  type        = list(string)
  description = "List of IP addresses to allow access to the Azure AI service."
  default     = []
}
