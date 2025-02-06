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
