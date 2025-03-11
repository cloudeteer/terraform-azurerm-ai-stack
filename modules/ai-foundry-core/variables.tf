variable "ai_developer_principal_id" {
  type = string

  description = <<-DESCRIPTION
    The principal ID of a user or group of AI Developers who will have access to this AI Foundry Hub.

    The following roles will be assigned to the given principal ID:

    Role | Scope
    -- | --
    Azure AI Developer | AI Foundry Hub
    Azure AI Developer | AI Foundry Project
    Contributor | Developer Resource Group
    Storage Blob Data Contributor | Storage Account
    Storage File Data Privileged Contributor | Storage Account
  DESCRIPTION

  default = null
}

variable "allowed_ips" {
  type        = list(string)
  description = "List of IP addresses to allow access to the service."
  default     = []
  nullable    = false
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
    isolation_mode = optional(string, "AllowOnlyApprovedOutbound")
  })

  default = {}

  description = <<-DESCRIPTION
    Network configuration for the AI Hub.

    Optional arguments:

    Argument | Description
    -- | --
    `isolation_mode` | Isolation mode for the managed network of a machine learning workspace. Possible values are `AllowOnlyApprovedOutbound`, `AllowInternetOutbound`, or `Disabled`.

    **NOTE**:
  DESCRIPTION
}

variable "location" {
  type        = string
  description = "Location of the resource group."
  default     = "swedencentral"
  nullable    = false
}

variable "basename" {
  type        = string
  description = "The name of the this resource."
}

variable "public_network_access" {
  type        = bool
  description = "Allow Public Access on AI Services, Storage Account, Key Vault, etc."
  default     = false
}

variable "resource_group_id" {
  type        = string
  description = "The resource group ID where the resources will be deployed."
}

variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
}
