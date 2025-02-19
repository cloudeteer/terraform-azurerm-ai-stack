<!-- BEGIN_TF_DOCS -->
## Usage

This example demonstrates the usage of this Terraform module with default settings.

```hcl
module "ai_foundry_core" {
  source = "cloudeteer/azure-ai-foundry-hub/azurerm//modules/ai-foundry-core"

  name                = var.name
  location            = var.location
  resource_group_id   = local.resource_group_id
  resource_group_name = var.resource_group_name
}
```

## Providers

The following providers are used by this module:

- <a name="provider_azapi"></a> [azapi](#provider\_azapi) ( >= 2.0)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 4.1)

- <a name="provider_random"></a> [random](#provider\_random) (~> 3.1)



## Resources

The following resources are used by this module:

- [azapi_resource.hub](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource.project](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) (resource)
- [azurerm_resource_group.developer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_role_assignment.hub_ai_developer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.project](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.rg_developer_ai_developer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.storage_account_ai_developer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) (resource)
- [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_name"></a> [name](#input\_name)

Description: The name of the this resource.

Type: `string`

### <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id)

Description: The resource group ID where the resources will be deployed.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The resource group where the resources will be deployed.

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

### <a name="input_description"></a> [description](#input\_description)

Description: The description of this workspace.

Type: `string`

Default: `""`

### <a name="input_friendly_name"></a> [friendly\_name](#input\_friendly\_name)

Description: The friendly name for this workspace. This value in mutable.

Type: `string`

Default: `""`

### <a name="input_hub_network_config"></a> [hub\_network\_config](#input\_hub\_network\_config)

Description: Network configuration for the AI Hub.

Optional arguments:

Argument | Description
-- | --
`isolation_mode` | Isolation mode for the managed network of a machine learning workspace. Possible values are `AllowOnlyApprovedOutbound`, `AllowInternetOutbound`, or `Disabled`.

**NOTE**:

Type:

```hcl
object({
    isolation_mode = optional(string, "AllowOnlyApprovedOutbound")
  })
```

Default: `{}`

### <a name="input_location"></a> [location](#input\_location)

Description: Location of the resource group.

Type: `string`

Default: `"eastus"`

### <a name="input_public_network_access"></a> [public\_network\_access](#input\_public\_network\_access)

Description: Allow Public Access on AI Services, Storage Account, Key Vault, etc.

Type: `bool`

Default: `false`

## Outputs

The following outputs are exported:

### <a name="output_hub_id"></a> [hub\_id](#output\_hub\_id)

Description: The Azure Foundry Hub ID

### <a name="output_hub_management_url"></a> [hub\_management\_url](#output\_hub\_management\_url)

Description: The management URL for the AI Foundry Hub on the Azure AI platform

### <a name="output_project_management_url"></a> [project\_management\_url](#output\_project\_management\_url)

Description: The management URL for the AI Foundry Project on the Azure AI platform

### <a name="output_project_url"></a> [project\_url](#output\_project\_url)

Description: The URL to access the AI Foundry Project on the Azure AI platform

### <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id)

Description: The Azure Storage Account ID
<!-- END_TF_DOCS -->
