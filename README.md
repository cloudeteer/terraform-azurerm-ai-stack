<!-- markdownlint-disable first-line-h1 no-inline-html -->

> [!NOTE]
> This repository is publicly accessible as part of our open-source initiative. We welcome contributions from the community alongside our organization's primary development efforts.

---

# terraform-azurerm-ai-stack

[![Terraform Registry](https://img.shields.io/badge/Terraform%20Registry-ai--stack-7B42BC?style=for-the-badge&logo=terraform&logoColor=A067DA)](https://registry.terraform.io/modules/cloudeteer/ai-stack/azurerm)
[![OpenTofu Registry](https://img.shields.io/badge/OpenTofu%20Registry-ai--stack-4B4B77?style=for-the-badge&logo=opentofu)](https://search.opentofu.org/module/cloudeteer/ai-stack/azurerm)
[![SemVer](https://img.shields.io/badge/SemVer-2.0.0-F77F00?style=for-the-badge)](https://github.com/cloudeteer/terraform-azurerm-ai-stack/releases)

This Terraform module is composed of several submodules, which are combined in the primary module to provide a complete solution. Each submodule can also be deployed independently—see [./modules/](./modules/) for details.

For a typical deployment, refer to the quick start [Usage](#usage) example below or the examples provided in each submodule's documentation.

The module enables you to quickly and easily deploy a comprehensive AI stack on Azure, supporting everything from initial AI development to production- and enterprise-ready solutions.

We apply the highest security standards regarding networking and authentication. By default, all Azure services in this module have API key support disabled and communicate securely via Azure Identities (Entra ID Service Principals).

> [!NOTE]
> This module uses both [`azurerm` provider](https://registry.terraform.io/providers/hashicorp/azurerm) and [`azapi` provider](https://registry.terraform.io/providers/Azure/azapi) resources for Azure AI services that are not yet fully supported by the `azurerm` provider. You must configure the `azapi` provider, especially [authentication](https://registry.terraform.io/providers/Azure/azapi/latest/docs#authenticating-to-azure), in your root module.

> [!CAUTION]
> Once the `azurerm` provider fully supports all required resources for this module, we will migrate from `azapi` resources to `azurerm` resources. **This will introduce breaking changes** and will be released as a new major version in accordance with semantic versioning.

## RBAC

### Azure AI Service Role Assignments

> [!IMPORTANT]
> By default (`create_rbac = true`), this module creates all necessary Azure role assignments to enable secure communication between services. Assigning Azure roles requires Owner permissions on the resource group where the AI stack is deployed. If you do not have these permissions, you can disable role assignment creation (`create_rbac = false`). In this case, you must manually create the required Azure role assignments for the various AI service identities to ensure proper functionality.

The following role assignments are created to enable communication between AI services:

| Role                                  | Scope             | Principal                  |
| ------------------------------------- | ----------------- | -------------------------- |
| Cognitive Services OpenAI Contributor | AI Service        | AI Search Service Identity |
| Search Index Data Reader              | AI Search Service | AI Service Identity        |
| Search Service Contributor            | AI Search Service | AI Service Identity        |
| Storage Blob Data Contributor         | Storage Account   | AI Service Identity        |
| Storage Blob Data Reader              | Storage Account   | AI Search Service Identity |

### AI Developer Role

> [!TIP]
> You will likely want to set the `ai_developer_principal_id` variable to grant an Entra ID group or user access to the AI stack and permissions on the individual Azure AI services.

If `ai_developer_principal_id` is set (optional), the following roles are assigned to the specified principal:

| Role                                     | Scope                    |
| ---------------------------------------- | ------------------------ |
| Azure AI Developer                       | AI Foundry Hub           |
| Azure AI Developer                       | AI Foundry Project       |
| Contributor                              | Developer Resource Group |
| Storage Blob Data Contributor            | Storage Account          |
| Storage File Data Privileged Contributor | Storage Account          |
| Cognitive Services Contributor           | AI Service               |
| Cognitive Services OpenAI Contributor    | AI Service               |
| Cognitive Services User                  | AI Service               |
| User Access Administrator                | AI Service               |
| Search Index Data Contributor            | AI Search Service        |
| Search Service Contributor               | AI Search Service        |

This module creates a dedicated developer resource group, granting the specified group or user (`ai_developer_principal_id`) Owner permissions. This ensures that AI developers can create additional resources without mixing them into the main resource group (`resource_group_name`) where the module's Terraform resources are deployed. The developer resource group can be disabled if not needed.◊

## External Resources

The following resources were referenced during the development of this module and may be helpful for further module development:

### Azure AI Foundry Hub

- <https://learn.microsoft.com/en-us/azure/templates/microsoft.machinelearningservices/2024-10-01-preview/workspaces?pivots=deployment-language-terraform>
- <https://learn.microsoft.com/en-us/azure/ai-studio/how-to/configure-private-link>
- <https://learn.microsoft.com/en-us/azure/ai-studio/how-to/secure-data-playground>
- <https://learn.microsoft.com/en-us/azure/machine-learning/how-to-managed-network>
- <https://learn.microsoft.com/en-us/azure/ai-studio/concepts/rbac-ai-studio>
- <https://learn.microsoft.com/en-us/azure/ai-studio/tutorials/deploy-chat-web-app>

### Azure AI Service

- <https://learn.microsoft.com/en-us/azure/ai-services/cognitive-services-virtual-networks>
- <https://learn.microsoft.com/en-us/azure/ai-services/disable-local-auth>

### Azure AI Search Service

- <https://learn.microsoft.com/en-us/azure/templates/microsoft.search/2025-02-01-preview/searchservices>
- <https://github.com/MicrosoftDocs/azure-ai-docs/blob/main/articles/ai-services/openai/how-to/use-web-app.md>
- <https://github.com/microsoft/sample-app-aoai-chatGPT?tab=readme-ov-file#using-microsoft-entra-id>

### Blogs on AI Foundry

- <https://journeyofthegeek.com/2025/01/08/ai-foundry-the-basics/>
- <https://journeyofthegeek.com/2025/01/13/ai-foundry-credential-vs-identity-data-stores/>
- <https://journeyofthegeek.com/2025/01/27/ai-foundry-identity-authentication-and-authorization/>
- <https://www.georgeollis.com/using-managed-private-endpoints-in-azure-ai-foundry/>

### Modules and Code from the Community

- <https://github.com/Azure/terraform-azurerm-avm-res-machinelearningservices-workspace>
- <https://github.com/Azure/terraform-azurerm-avm-ptn-ai-foundry-enterprise>

<!-- BEGIN_TF_DOCS -->
## Usage

This example demonstrates the usage of this Terraform module with default settings.

```hcl
resource "azurerm_resource_group" "example" {
  location = "swedencentral"
  name     = "rg-example-dev-swec-01"
}

module "example" {
  source = "cloudeteer/ai-stack/azurerm"

  # Use the resource group name (without the 'rg-' prefix) as the base name for all resources
  basename            = trimprefix(azurerm_resource_group.example.name, "rg-")
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  # Enable public network access for all resources.
  # This should only be used in development or non-production environments.
  public_network_access = true
  # Optionally restrict access to specific IP addresses by setting allowed_ips.
  # allowed_ips           = []

  # Automatically create role assignments for AI services using Entra ID (Managed Identities).
  # Requires the user to have at least the Owner role on the resource group.
  # If set to false, you must manually create the necessary role assignments.
  # See the 'create_rbac' input variable documentation for more details.
  create_rbac = true # (default)

  # Enable local API key authentication for services.
  # This is currently required for chatbot integration.
  local_authentication_enabled = true

  # Deploy the chatbot submodule as part of the AI stack.
  # For additional configuration options, refer to ./modules/app-chatbot/README.md
  chatbot = {
    enabled = true
  }
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

### <a name="module_app_chatbot"></a> [app\_chatbot](#module\_app\_chatbot)

Source: ./modules/app-chatbot

Version:

## Resources

The following resources are used by this module:

- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_basename"></a> [basename](#input\_basename)

Description: The basename of all resources deployed by this module. Please use only 28 characters or less.

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

### <a name="input_chatbot"></a> [chatbot](#input\_chatbot)

Description: Configuration options for deploying the chatbot submodule as part of the AI Foundry Hub. This variable allows you to enable or disable chatbot, customize its deployment, specify container images, environment variables, and provide advanced configuration such as custom domains, model selection, and branding.

Required arguments:

Argument | Description
-- | --
`enabled` | Set to `true` to deploy the chatbot submodule. Defaults to `false`.

Optional arguments:

Argument | Description
-- | --
`api` | A `api` object for API configuration, as defined below.
`container_registry` | A `container_registry` object specifying the Azure Container Registry to pull container images from.
`models` | List of model names to expose in the chatbot frontend. Each model must be deployed via `var.models`.
`ui` | A `ui` object for UI configuration, as defined below.

`api` object arguments:

Argument | Description
-- | --
`container_image` | Container image for the chatbot frontend. If omitted, the default image will be used.
`envs` | Map of environment variables to inject into the chatbot container application.
`custom_domain_name` | Custom subdomain for the chatbot application. If not specified, a default subdomain in the format `<region>.azurecontainerapps.io` will be used.

`container_registry` object arguments:

Argument | Description
-- | --
`server` | Hostname of the Azure Container Registry (the `server` output of an `azurerm_container_registry` resource).
`id` | Resource ID of the Azure Container Registry.
`create_rbac` | Specifies whether to create role assignments that grant the container app's managed identity permissions to pull images from the container registry. Defaults to `true`.

`ui` object arguments:

Argument | Description
-- | --
`container_image` | Container image for the chatbot frontend. If omitted, the default image will be used.
`envs` | Map of environment variables to inject into the chatbot container application.
`custom_domain_name` | Custom subdomain for the chatbot application. If not specified, a default subdomain in the format `<region>.azurecontainerapps.io` will be used.

Type:

```hcl
object({
    enabled = bool
    models  = optional(list(string))

    api = optional(object({
      container_image    = optional(string)
      envs               = optional(map(string), {})
      custom_domain_name = optional(string)
    }), {})

    container_registry = optional(object({
      server      = string
      id          = string
      create_rbac = optional(bool, true)
    }))

    entra_id_auth = optional(object({
      tenant_id     = string
      client_id     = string
      client_secret = string
    }))

    ui = optional(object({
      container_image    = optional(string)
      envs               = optional(map(string), {})
      custom_domain_name = optional(string)
    }), {})
  })
```

Default:

```json
{
  "enabled": false
}
```

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

### <a name="input_names"></a> [names](#input\_names)

Description: Allow overwrite the names of specific resources, instead of using generated names by this module bases on `var.basename`. This can be handy when importing existing resources which name should not change, or when having custom naming convetions this module does not consider.

Type:

```hcl
object({
    chatbot_container_app_ui  = optional(string)
    chatbot_container_app_api = optional(string)
  })
```

Default: `{}`

### <a name="input_public_network_access"></a> [public\_network\_access](#input\_public\_network\_access)

Description: Allow Public Access on AI Services, Storage Account, Key Vault, etc.

Type: `bool`

Default: `false`

### <a name="input_search_service_sku"></a> [search\_service\_sku](#input\_search\_service\_sku)

Description: The SKU which should be used for this Search Service. Possible values include basic, free, standard, standard2, standard3, storage\_optimized\_l1 and storage\_optimized\_l2. Changing this forces a new Search Service to be created. Some SKU´s may with some restrictions. See https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/search_service#sku-1

Type: `string`

Default: `"standard"`

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

### <a name="output_chatbot_api_container_app_id"></a> [chatbot\_api\_container\_app\_id](#output\_chatbot\_api\_container\_app\_id)

Description: The Azure Container Application resource ID of the chatbot API

### <a name="output_chatbot_api_principal_id"></a> [chatbot\_api\_principal\_id](#output\_chatbot\_api\_principal\_id)

Description: The principal ID of the managed identity assigned to the Container App running the chatbot frontend application

### <a name="output_chatbot_ui_container_app_id"></a> [chatbot\_ui\_container\_app\_id](#output\_chatbot\_ui\_container\_app\_id)

Description: The Azure Container Application resource ID of the chatbot UI

### <a name="output_chatbot_ui_principal_id"></a> [chatbot\_ui\_principal\_id](#output\_chatbot\_ui\_principal\_id)

Description: The principal ID of the managed identity assigned to the Container App running the chatbot frontend application

### <a name="output_hub_id"></a> [hub\_id](#output\_hub\_id)

Description: The Azure Foundry Hub ID

### <a name="output_hub_management_url"></a> [hub\_management\_url](#output\_hub\_management\_url)

Description: The management URL for the AI Foundry Hub on the Azure AI platform

### <a name="output_hub_principal_id"></a> [hub\_principal\_id](#output\_hub\_principal\_id)

Description: The principal ID of the managed identity assigned to the Azure Foundry Hub

### <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id)

Description: The Azure Key Vault ID

### <a name="output_project_id"></a> [project\_id](#output\_project\_id)

Description: The Azure Foundry Project ID

### <a name="output_project_management_url"></a> [project\_management\_url](#output\_project\_management\_url)

Description: The management URL for the AI Foundry Project on the Azure AI platform

### <a name="output_project_principal_id"></a> [project\_principal\_id](#output\_project\_principal\_id)

Description: The principal ID of the managed identity assigned to the Azure Foundry Project

### <a name="output_project_url"></a> [project\_url](#output\_project\_url)

Description: The URL to access the AI Foundry Project on the Azure AI platform

### <a name="output_search_service_id"></a> [search\_service\_id](#output\_search\_service\_id)

Description: The ID of the AI service

### <a name="output_search_service_name"></a> [search\_service\_name](#output\_search\_service\_name)

Description: The name of the AI service

### <a name="output_search_service_primary_key"></a> [search\_service\_primary\_key](#output\_search\_service\_primary\_key)

Description: A primary access key which can be used to connect to the AI Services Account.

### <a name="output_search_service_principal_id"></a> [search\_service\_principal\_id](#output\_search\_service\_principal\_id)

Description: The principal ID of the managed identity assigned to the Azure AI Search Service

### <a name="output_search_service_secondary_key"></a> [search\_service\_secondary\_key](#output\_search\_service\_secondary\_key)

Description: A secondary access key which can be used to connect to the AI Services Account.
<!-- END_TF_DOCS -->

## Contributions

We welcome all kinds of contributions, whether it's reporting bugs, submitting feature requests, or directly contributing to the development. Please read our [Contributing Guidelines](CONTRIBUTING.md) to learn how you can best contribute.

Thank you for your interest and support!

## Copyright and license

<img width=200 alt="Logo" src="https://raw.githubusercontent.com/cloudeteer/cdt-public/main/img/cdt_logo_orig_4c.svg">

© 2024 CLOUDETEER GmbH

This project is licensed under the [MIT License](LICENSE).
