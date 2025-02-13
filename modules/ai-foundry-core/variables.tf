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

variable "location" {
  type        = string
  default     = "eastus"
  description = "Location of the resource group."
}

variable "name" {
  type        = string
  description = "The name of the this resource."
}

variable "resource_group_id" {
  type        = string
  description = "The resource group ID where the resources will be deployed."
}

variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
}
