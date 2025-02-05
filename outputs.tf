output "endpoint" {
  value = azurerm_ai_services.this.endpoint
}

output "resource_group_name" {
  value = azurerm_resource_group.this.id
}

output "workspace_name" {
  value = azapi_resource.project.id
}
