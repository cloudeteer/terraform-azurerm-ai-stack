# This override file is mandatory for Terraform tests.
# Not needed to use this example.
terraform {
  # add all providers used in the module to run tests
  #required_providers {
  #  random = { source = "hashicorp/random" }
  #}
}

module "example" { source = "../.." }
