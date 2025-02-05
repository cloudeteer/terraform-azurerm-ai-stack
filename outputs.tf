output "endpoint" {
  value       = azurerm_ai_services.this.endpoint
  description = "The endpoint used to connect to the AI Services Account."
}

output "workspace_name" {
  value       = azapi_resource.project.id
  description = "The ID of the Azure AI project workspace."
}
