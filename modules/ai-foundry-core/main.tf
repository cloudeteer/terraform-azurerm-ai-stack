locals {
  random_string_length = 3
}

resource "random_string" "suffix" {
  length  = local.random_string_length
  special = false
  upper   = false
}
