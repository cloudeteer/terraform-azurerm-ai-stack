variable "api" {
  description = <<-DESCRIPTION

  `enabled` | Enable the API component deployment.


  `container_image` | Container image reference for the API backend service.
  `cpu` | CPU allocation (in cores) for the API container.
  `custom_domain_name` | "Custom domain name to be used for the API."
  `envs` | "Map of environment variables to set in the API container."
  `memory` | "Memory allocation for the API container (e.g., '0.5Gi')."
  DESCRIPTION

  type = object({
    enabled            = bool
    container_image    = optional(string, "ghcr.io/cloudeteer/cloudetair-chatbot-api:latest")
    cpu                = optional(number, 0.25)
    custom_domain_name = optional(string)
    envs               = optional(map(string), {})
    memory             = optional(string, "0.5Gi")
  })

  default = {
    enabled = true
  }
}

variable "basename" {
  type        = string
  description = "The basename of all resources deployed by this module"
}

variable "container_registry" {
  type = object({
    id                   = string
    server               = string
    identity             = optional(string) # desc: default uses the identity brought by this module
    password_secret_name = optional(string)
    username             = optional(string)
  })
  description = "Container registry configuration object, including registry ID, server address, and optional authentication details."
  default     = null
}

variable "entra_id_auth" {
  description = "Configure Entra ID OIDC authentication on the chatbot UI."

  type = object({
    tenant_id     = string
    client_id     = string
    client_secret = string
    # required_group = optional(string)
  })
  default = null
}

variable "location" {
  type        = string
  description = "Azure region where the resource group and resources will be deployed."
  default     = "swedencentral"
  nullable    = false
}

variable "names" {
  description = "Allow overwrite the names of specific resources, instead of using generated names by this module bases on `var.basename`. This can be handy when importing existing resources which name should not change, or when having custom naming convetions this module does not consider."

  type = object({
    container_app_ui  = optional(string)
    container_app_api = optional(string)
  })

  default = {}
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Azure resource group where all resources will be deployed."
}

variable "ui" {
  description = <<-DESCRIPTION

  `enabled` | Enable the UI component deployment.


  `container_image` | Container image reference for the UI backend service.
  `cpu` | CPU allocation (in cores) for the UI container.
  `envs` | "Map of environment variables to set in the UI container."
  `memory` | "Memory allocation for the UI container (e.g., '0.5Gi')."
  `custom_domain_name` | "Custom domain name to be used for the UI."
  DESCRIPTION

  type = object({
    enabled            = optional(bool, true)
    container_image    = optional(string, "ghcr.io/cloudeteer/cloudetair-chatbot-ui:latest")
    cpu                = optional(number, 0.25)
    custom_domain_name = optional(string)
    envs               = optional(map(string), {})
    memory             = optional(string, "0.5Gi")
  })

  default = {
    enabled = true
  }
}
