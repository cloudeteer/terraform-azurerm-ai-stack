<!-- markdownlint-disable first-line-h1 no-inline-html -->

> [!NOTE]
> This repository is publicly accessible as part of our open-source initiative. We welcome contributions from the community alongside our organization's primary development efforts.

---

# terraform-module-template

[![SemVer](https://img.shields.io/badge/SemVer-2.0.0-blue.svg)](https://github.com/cloudeteer/terraform-module-template/releases)

Terraform Module Template

<!-- BEGIN_TF_DOCS -->
## Usage

This example demonstrates the usage of this Terraform module with default settings.

```hcl
data "http" "my_current_public_ip" { url = "https://ipv4.icanhazip.com" }

resource "azurerm_resource_group" "example" {
  location = "swedencentral"
  name     = "rg-example-dev-swec-01"
}

module "example" {
  source = "cloudeteer/azure-ai-foundry-hub/azurerm"

  basename            = trimprefix(azurerm_resource_group.example.name, "rg-")
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  public_network_access = true
  allowed_ips           = [chomp(data.http.my_current_public_ip.response_body)]
}
```

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 4.14)

## Modules

The following Modules are called:

### <a name="module_ai_foundry_core"></a> [ai\_foundry\_core](#module\_ai\_foundry\_core)

Source: ./modules/ai-foundry-core

Version:

### <a name="module_ai_foundry_services"></a> [ai\_foundry\_services](#module\_ai\_foundry\_services)

Source: ./modules/ai-foundry-services

Version:

## Resources

The following resources are used by this module:

- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_basename"></a> [basename](#input\_basename)

Description: The name of the this resource.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The resource group where the resources will be deployed.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_ai_developer_principal_id"></a> [ai\_developer\_principal\_id](#input\_ai\_developer\_principal\_id)

Description: The principal ID of a user or group of AI Developers who will have access to this AI Foundry Hub.

The following roles will be assigned to the given principal ID:

| Role | Scope |
| -- | -- |
| Azure AI Developer | AI Foundry Hub |
| Azure AI Developer | AI Foundry Project |
| Contributor | Developer Resource Group |
| Storage Blob Data Contributor | Storage Account |
| Storage File Data Privileged Contributor | Storage Account |
| Cognitive Services Contributor | AI Service |
| Cognitive Services OpenAI Contributor | AI Service |
| Cognitive Services User | AI Service |
| User Access Administrator | AI Service |
| Search Index Data Contributor | AI Search Service |
| Search Service Contributor | AI Search Service |

Argument | Description
-- | --
`isolation_mode` | Isolation mode for the managed network of a machine learning workspace. Possible values are `AllowOnlyApprovedOutbound`, `AllowInternetOutbound`, or `Disabled`.
`public_network_access` | Whether requests from Public Network are allowed.

**NOTE**: The `User Access Administrator` role is assigned with the condition that only the `Cognitive Services OpenAI User` role can be assigned to user principals. This is necessary to successfully deploy a Web App on top of an AI Model through the AI Foundry Hub.

Type: `string`

Default: `null`

### <a name="input_allowed_ips"></a> [allowed\_ips](#input\_allowed\_ips)

Description: List of IP addresses to allow access to the Azure AI service.

Type: `list(string)`

Default: `[]`

### <a name="input_create_rbac"></a> [create\_rbac](#input\_create\_rbac)

Description: If set to `true` (default), the following mandatory Azure role assignments will be created:

| Role | Scope | Principal |
| -- | -- | -- |
| Cognitive Services OpenAI Contributor | AI Service | AI Search Service Identity |
| Search Index Data Reader | AI Search Service | AI Service Identity |
| Search Service Contributor | AI Search Service | AI Service Identity |
| Storage Blob Data Contributor | Storage Account | AI Service Identity |
| Storage Blob Data Reader | Storage Account | AI Search Service Identity |

**NOTE**: If set to `false`, these role assignments must be created manually to ensure the AI Foundry Hub Project functions correctly.

Type: `bool`

Default: `true`

### <a name="input_description"></a> [description](#input\_description)

Description: The description of this workspace.

Type: `string`

Default: `null`

### <a name="input_friendly_name"></a> [friendly\_name](#input\_friendly\_name)

Description: The friendly name for this workspace. This value in mutable.

Type: `string`

Default: `null`

### <a name="input_hub_network_config"></a> [hub\_network\_config](#input\_hub\_network\_config)

Description: Network configuration for the AI Hub.

Optional arguments:

Argument | Description
-- | --
`isolation_mode` | Isolation mode for the managed network of a machine learning workspace. Possible values are `AllowOnlyApprovedOutbound`, `AllowInternetOutbound`, or `Disabled`.
`public_network_access` | Whether requests from Public Network are allowed.

**NOTE**:

Type:

```hcl
object({
    isolation_mode        = optional(string, "AllowOnlyApprovedOutbound")
    public_network_access = optional(bool, false)
  })
```

Default: `{}`

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
`format` | The format of the Cognitive Services Account Deployment model. Changing this forces a new resource to be created. Possible value is `OpenAI`.
`sku_capacity` | Tokens-per-Minute (TPM). The unit of measure for this field is in the thousands of Tokens-per-Minute. Defaults to `1` which means that the limitation is `1000` tokens per minute. If the resources SKU supports scale in/out then the capacity field should be included in the resources' configuration. If the scale in/out is not supported by the resources SKU then this field can be safely omitted. For more information about TPM please see the [product documentation](https://learn.microsoft.com/azure/ai-services/openai/how-to/quota?tabs=rest).
`sku_name` | The name of the SKU. Possible values include `Standard`, `DataZoneStandard`, `DataZoneProvisionedManaged`, `GlobalBatch`, `GlobalProvisionedManaged`, `GlobalStandard`, and `ProvisionedManaged`.
`version` | The version of Cognitive Services Account Deployment model. If `version` is not specified, the default version of the model at the time will be assigned.

**Note**: `DataZoneProvisionedManaged`, `GlobalProvisionedManaged`, and `ProvisionedManaged` are purchased on-demand at an hourly basis based on the number of deployed PTUs, with substantial term discount available via the purchase of Azure Reservations. Currently, this step cannot be completed using Terraform. For more details, please refer to the [provisioned throughput onboarding documentation](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/provisioned-throughput-onboarding).

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

### <a name="input_public_network_access"></a> [public\_network\_access](#input\_public\_network\_access)

Description: Allow Public Access on AI Services, Storage Account, Key Vault, etc.

Type: `bool`

Default: `false`

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

### <a name="output_hub_management_url"></a> [hub\_management\_url](#output\_hub\_management\_url)

Description: The management URL for the AI Foundry Hub on the Azure AI platform

### <a name="output_project_management_url"></a> [project\_management\_url](#output\_project\_management\_url)

Description: The management URL for the AI Foundry Project on the Azure AI platform

### <a name="output_project_url"></a> [project\_url](#output\_project\_url)

Description: The URL to access the AI Foundry Project on the Azure AI platform
<!-- END_TF_DOCS -->

## Contributions

We welcome all kinds of contributions, whether it's reporting bugs, submitting feature requests, or directly contributing to the development. Please read our [Contributing Guidelines](CONTRIBUTING.md) to learn how you can best contribute.

Thank you for your interest and support!

## Copyright and license

<img width=200 alt="Logo" src="https://raw.githubusercontent.com/cloudeteer/cdt-public/main/img/cdt_logo_orig_4c.svg">

© 2024 CLOUDETEER GmbH

This project is licensed under the [MIT License](LICENSE).
