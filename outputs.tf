output "ai_service_endpoint" {
  value       = module.ai_foundry_services.ai_service_endpoint
  description = "The endpoint of the AI service"
}

output "ai_service_id" {
  value       = module.ai_foundry_services.ai_service_id
  description = "The ID of the AI service"
}

output "hub_management_url" {
  description = "The management URL for the AI Foundry Hub on the Azure AI platform"
  value       = module.ai_foundry_core.hub_management_url
}

output "project_management_url" {
  description = "The management URL for the AI Foundry Project on the Azure AI platform"
  value       = module.ai_foundry_core.project_management_url
}

output "project_url" {
  description = "The URL to access the AI Foundry Project on the Azure AI platform"
  value       = module.ai_foundry_core.project_url
}
