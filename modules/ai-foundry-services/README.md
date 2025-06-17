<!-- BEGIN_TF_DOCS -->
## Usage

This example demonstrates the usage of this Terraform module with default settings.

```hcl
module "ai_foundry_services" {
  source = "cloudeteer/azure-ai-foundry-hub/azurerm//modules/ai-foundry-services"

  name                = var.basename
  location            = var.location
  resource_group_name = var.resource_group_name

  sku    = var.sku
  hub_id = module.ai_foundry_core.hub_id
}
```

## Providers

The following providers are used by this module:

- <a name="provider_azapi"></a> [azapi](#provider\_azapi) ( >= 2.0)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 4.14)

- <a name="provider_random"></a> [random](#provider\_random) ( >= 3.6)



## Resources

The following resources are used by this module:

- [azapi_resource.ai_services_connection_hub](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource.ai_services_outbound_rule_hub](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource.search_service_connection_hub](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
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

### <a name="input_basename"></a> [basename](#input\_basename)

Description: The basename of all resources deployed by this module

Type: `string`

### <a name="input_hub_id"></a> [hub\_id](#input\_hub\_id)

Description: The ID of the Azure AI hub.

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

The following roles will be assigned to the given principal ID:

| Role | Scope |
| -- | -- |
| Cognitive Services Contributor | AI Service |
| Cognitive Services OpenAI Contributor | AI Service |
| Cognitive Services User | AI Service |
| User Access Administrator | AI Service |
| Search Index Data Contributor | AI Search Service |
| Search Service Contributor | AI Search Service |

**NOTE**: The `User Access Administrator` role is assigned with the condition that only the `Cognitive Services OpenAI User` role can be assigned to user principals. This is necessary to successfully deploy a Web App on top of an AI Model through the AI Foundry Hub.

Type: `string`

Default: `null`

### <a name="input_allowed_ips"></a> [allowed\_ips](#input\_allowed\_ips)

Description: List of IP addresses to allow access to the service.

Type: `list(string)`

Default: `[]`

### <a name="input_create_rbac"></a> [create\_rbac](#input\_create\_rbac)

Description: If set to `true` (default), the following mandatory Azure role assignments will be created automatically:

| Role | Scope | Principal |
| -- | -- | -- |
| Cognitive Services OpenAI Contributor | AI Service | AI Search Service Identity |
| Search Index Data Reader | AI Search Service | AI Service Identity |
| Search Service Contributor | AI Search Service | AI Service Identity |
| Storage Blob Data Contributor | Storage Account (AI Foundry Hub) | AI Service Identity |
| Storage Blob Data Reader | Storage Account (AI Foundry Hub) | AI Search Service Identity |

**NOTE**: If set to `false`, these role assignments must be created manually to ensure the AI Foundry Hub Project functions correctly.

Type: `bool`

Default: `true`

### <a name="input_local_authentication_enabled"></a> [local\_authentication\_enabled](#input\_local\_authentication\_enabled)

Description: Specifies whether the services allows authentication using local API keys.

Type: `bool`

Default: `true`

### <a name="input_location"></a> [location](#input\_location)

Description: Location of the resource group.

Type: `string`

Default: `"swedencentral"`

### <a name="input_models"></a> [models](#input\_models)

Description: A list of models to deploy to the workspace.

Required parameters:

Parameter | Description
-- | --
`name` | The name of the Cognitive Services Account Deployment model. Changing this forces a new resource to be created.

Optional parameters:

Parameter | Description
-- | --
`deployment_name` | The name to assign to the model deployment. If not specified, the value of `name` will be used by default. This property allows you to customize the deployment resource name independently from the model name.
`format` | The format of the Cognitive Services Account Deployment model. Changing this forces a new resource to be created. Possible value is `OpenAI`.
`sku_capacity` | Tokens-per-Minute (TPM). The unit of measure for this field is in the thousands of Tokens-per-Minute. Defaults to `1` which means that the limitation is `1000` tokens per minute. If the resources SKU supports scale in/out then the capacity field should be included in the resources' configuration. If the scale in/out is not supported by the resources SKU then this field can be safely omitted. For more information about TPM please see the [product documentation](https://learn.microsoft.com/azure/ai-services/openai/how-to/quota?tabs=rest).
`sku_name` | The name of the SKU. Possible values include `Standard`, `DataZoneStandard`, `DataZoneProvisionedManaged`, `GlobalBatch`, `GlobalProvisionedManaged`, `GlobalStandard`, and `ProvisionedManaged`.
`version` | The version of Cognitive Services Account Deployment model. If `version` is not specified, the default version of the model at the time will be assigned.

**Note**: `DataZoneProvisionedManaged`, `GlobalProvisionedManaged`, and `ProvisionedManaged` are purchased on-demand at an hourly basis based on the number of deployed PTUs, with substantial term discount available via the purchase of Azure Reservations. Currently, this step cannot be completed using Terraform. For more details, please refer to the [provisioned throughput onboarding documentation](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/provisioned-throughput-onboarding).

Type:

```hcl
list(object({
    name            = string
    deployment_name = optional(string)
    format          = optional(string)
    sku_capacity    = optional(number)
    sku_name        = optional(string)
    version         = optional(string)
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

### <a name="output_search_service_id"></a> [search\_service\_id](#output\_search\_service\_id)

Description: The ID of the AI service

### <a name="output_search_service_name"></a> [search\_service\_name](#output\_search\_service\_name)

Description: The name of the AI service

### <a name="output_search_service_principal_id"></a> [search\_service\_principal\_id](#output\_search\_service\_principal\_id)

Description: The principal ID of the managed identity assigned to the Azure AI Search Service
<!-- END_TF_DOCS -->
