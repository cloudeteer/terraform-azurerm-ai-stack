variable "location" {
  type        = string
  default     = "eastus"
  description = "Location of the resource group."
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

variable "hub_id" {
  type        = string
  description = "The ID of the Azure AI hub."
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
