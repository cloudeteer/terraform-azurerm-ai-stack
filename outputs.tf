output "endpoint" {
  value = azurerm_ai_services.this.endpoint
}

output "workspace_name" {
  value = azapi_resource.project.id
}
