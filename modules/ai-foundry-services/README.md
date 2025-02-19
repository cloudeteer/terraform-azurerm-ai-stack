<!-- BEGIN_TF_DOCS -->
## Usage

This example demonstrates the usage of this Terraform module with default settings.

```hcl
module "ai_foundry_services" {
  source = "cloudeteer/azure-ai-foundry-hub/azurerm//modules/ai-foundry-services"

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku    = var.sku
  hub_id = module.ai_foundry_core.hub_id
}
```

## Providers

The following providers are used by this module:

- <a name="provider_azapi"></a> [azapi](#provider\_azapi) ( >= 2.0)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 4.1)

- <a name="provider_random"></a> [random](#provider\_random) ( >= 3.6)



## Resources

The following resources are used by this module:

- [azapi_resource.ai_services_connection](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource.ai_services_connection_search_service](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource.ai_services_outbound_rule_hub](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource.search_service_outbound_rule_hub](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azurerm_ai_services.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/ai_services) (resource)
- [azurerm_cognitive_deployment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_deployment) (resource)
- [azurerm_role_assignment.ai_service_developer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.ai_service_developer_user_access_administrator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.ai_service_search_service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.search_service_ai_developer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.search_service_ai_service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.storage_account_ai_service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.storage_account_search_service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_search_service.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/search_service) (resource)
- [random_string.identifier](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_hub_id"></a> [hub\_id](#input\_hub\_id)

Description: The ID of the Azure AI hub.

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: The name of the this resource.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The resource group where the resources will be deployed.

Type: `string`

### <a name="input_storage_account_id"></a> [storage\_account\_id](#input\_storage\_account\_id)

Description: The ID of the Azure Storage Account.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_ai_developer_principal_id"></a> [ai\_developer\_principal\_id](#input\_ai\_developer\_principal\_id)

Description: The principal ID of a user or group of AI Developers who will have access to this AI Foundry Hub.

Type: `string`

Default: `""`

### <a name="input_allowed_ips"></a> [allowed\_ips](#input\_allowed\_ips)

Description: List of IP addresses to allow access to the service.

Type: `list(string)`

Default: `[]`

### <a name="input_create_rbac"></a> [create\_rbac](#input\_create\_rbac)

Description: Create Aure Role Assignments and grant all needed permissions to the `principal_id`.

Type: `bool`

Default: `false`

### <a name="input_local_authentication_enabled"></a> [local\_authentication\_enabled](#input\_local\_authentication\_enabled)

Description: Specifies whether the services allows authentication using local API keys.

Type: `bool`

Default: `false`

### <a name="input_location"></a> [location](#input\_location)

Description: Location of the resource group.

Type: `string`

Default: `"eastus"`

### <a name="input_models"></a> [models](#input\_models)

Description: A map of models to deploy to the workspace.

Type:

```hcl
list(object({
    name         = string
    format       = optional(string)
    sku_capacity = optional(number)
    sku_name     = optional(string)
    version      = optional(string)
  }))
```

Default: `[]`

### <a name="input_sku"></a> [sku](#input\_sku)

Description: The sku name of the Azure Analysis Services server to create. Choose from: B1, B2, D1, S0, S1, S2, S3, S4, S8, S9. Some skus are region specific. See https://docs.microsoft.com/en-us/azure/analysis-services/analysis-services-overview#availability-by-region

Type: `string`

Default: `"S0"`

## Outputs

The following outputs are exported:

### <a name="output_ai_service_endpoint"></a> [ai\_service\_endpoint](#output\_ai\_service\_endpoint)

Description: The endpoint of the AI service

### <a name="output_ai_service_id"></a> [ai\_service\_id](#output\_ai\_service\_id)

Description: The ID of the AI service
<!-- END_TF_DOCS -->
