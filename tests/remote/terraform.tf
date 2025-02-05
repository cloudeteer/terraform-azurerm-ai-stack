# Loaded by `run "setup"` in `main.test.hcl`
# This file is used to configure Terraform settings and required providers for remote tests.
terraform {
  # based on the version constraints use the lowest version of Terraform that is compatible
  required_version = "1.9.0"

  required_providers {
    # based on the version constraints use the lowest version of the provider that is compatible
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.1.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "2.0.1" # there is no version 2.0.0
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}
