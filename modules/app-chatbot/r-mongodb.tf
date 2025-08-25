# https://learn.microsoft.com/en-us/azure/cosmos-db/mongodb/vcore/
resource "azurerm_mongo_cluster" "this" {
  name                = "cosmon-${var.basename}"
  resource_group_name = var.resource_group_name
  location            = var.location

  # administrator_username = random_string.mongo_cluster_administrator_username.result # WTF?
  administrator_username = "mongoadmin81749571"
  administrator_password = random_password.mongo_cluster_administrator_password.result

  shard_count            = 1
  compute_tier           = "M10"
  high_availability_mode = "Disabled"
  storage_size_in_gb     = 32
  version                = "7.0"
}

resource "random_string" "mongo_cluster_administrator_username" {
  length  = 16
  special = false
  upper   = false
}

resource "random_password" "mongo_cluster_administrator_password" {
  length  = 32
  special = false
}

locals {
  mongo_cluser_connection_string = one([
    for connection_string in azurerm_mongo_cluster.this.connection_strings : connection_string.value
    if connection_string.name == "GlobalReadWrite"
  ])

  mongo_cluser_connection_string_baseurl = split("?", local.mongo_cluser_connection_string)[0]
  mongo_cluser_connection_string_query   = split("?", local.mongo_cluser_connection_string)[1]
}

resource "azapi_update_resource" "mongo_cluster" {
  type                   = "Microsoft.DocumentDB/mongoClusters@2025-04-01-preview"
  resource_id            = azurerm_mongo_cluster.this.id
  response_export_values = []

  body = {
    properties = {
      publicNetworkAccess = "Enabled"
    }
  }
}

resource "time_static" "this" {
  triggers = {
    mongo_cluster = azapi_update_resource.mongo_cluster.id
  }
}

resource "azapi_resource" "mongo_cluster_allow_azure_services" {
  type      = "Microsoft.DocumentDB/mongoClusters/firewallRules@2025-04-01-preview"
  parent_id = azurerm_mongo_cluster.this.id

  # This exact name is required by Azure to toggle the
  # "Allow public access from Azure services and resources within Azure" setting.
  name = "AllowAllAzureServicesAndResourcesWithinAzureIps_${formatdate("YYYY-M-D-h-m-s", time_static.this.rfc3339)}"

  body = {
    properties = {
      startIpAddress = "0.0.0.0"
      endIpAddress   = "0.0.0.0"
    }
  }
}
