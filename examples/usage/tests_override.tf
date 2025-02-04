# This override file is mandatory for Terraform tests.
# Not needed to use this example.
terraform {
  required_providers {
    # add all providers used in the module to run tests
    azurerm = { source = "hashicorp/azurerm" }
    azapi   = { source = "azure/azapi" }
    random  = { source = "hashicorp/random" }
  }
}

module "example" { source = "../.." }
