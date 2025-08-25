terraform {
  required_version = ">= 1.9"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = " >= 2.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.14"
    }
    random = {
      source  = "hashicorp/random"
      version = " >= 3.6"
    }
  }
}
