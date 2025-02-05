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

variable "workspace_description" {
  type        = string
  description = "The description of this workspace."
  default     = ""
}

variable "workspace_friendly_name" {
  type        = string
  description = "The friendly name for this workspace. This value in mutable."
  default     = ""
}
