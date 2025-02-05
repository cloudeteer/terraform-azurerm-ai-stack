output "endpoint" {
  value = azapi_resource.AIServicesResource.output.properties.endpoint
}

output "resource_group_name" {
  value = azurerm_resource_group.this.id
}

output "workspace_name" {
  value = azapi_resource.project.id
}
