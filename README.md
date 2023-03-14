## Terraform Azure - Rookout Deployment

This Terraform deploys Rookout Controller and Rookout Datastore using App Service on Azure cloud.

The module implements the following architectures (public/private deployments):

<img src="https://github.com/Rookout/terraform-azure-rookout-deployment/blob/main/documentation/Azure_Deployment_Private.jpg?raw=true" width="900">


<img src="https://github.com/Rookout/terraform-azure-rookout-deployment/blob/main/documentation/Azure_Deployment_Public.jpg?raw=true" width="900">

### Prerequisites 
1. Install Terraform.
2. [Configure Terraform for your Azure account](https://docs.microsoft.com/en-us/azure/developer/terraform/quickstart-configure).
3. Create a provider block as specified in the guide chosen above (for example in the [Azure Cloud Shell/Bash guide](https://docs.microsoft.com/en-us/azure/developer/terraform/get-started-cloud-shell-bash?tabs=bash#specify-service-principal-credentials-in-a-terraform-provider-block)). 
4. Get your organization's Rookout token from the [Rookout web application](https://app.rookout.com). The token must be passed as a variable to the module you will be creating.
   ```
   rookout_token = "..."
   ```

## Usage - Public
In this deployment, both the component controller and the datastore will be internet-facing. 
A public domain and Azure public hosted zone should be used for public deployments.

   ```hcl
   module "rookout" {
      source  = "Rookout/rookout-deployment/azure"
      # version = x.y.z
      
      domain_name = "YOUR_DOMAIN"
      domain_resource_group = "DOMAIN'S_RESOUCRE_GROUP"

      rookout_token = "YOUR_TOKEN"
   }
   ```

## Usage - Private (internal)
In this deployment, both the component controller and datastore are reachable only from virtual network. 
A private hosted zone will be created (for deployment to an existing virtual network, see the next section). 

The output of this module is the components url.

   ```hcl
   module "rookout" {
      source  = "Rookout/rookout-deployment/azure"
      # version = x.y.z
      
      rookout_token = "YOUR_TOKEN"
      internal = true
      }
   ```

## Existing virtual network
To use an existing virtual network, the following variables should be passed for both public and private deployments.

   ```hcl
   module "rookout" {
    ....
    
      create_vnet = false
      existing_vnet_name = "..."
      existing_resource_group_name = "..."

      subnet_app_serivce_cidr = "x.y.z.0/28"
      private_endpoint_subnet_cidr ="x.y.z.64/28"
   }
   ```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.17.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.17.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_app_service_certificate_binding.controller](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/app_service_certificate_binding) | resource |
| [azurerm_app_service_certificate_binding.datastore](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/app_service_certificate_binding) | resource |
| [azurerm_app_service_custom_hostname_binding.controller](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/app_service_custom_hostname_binding) | resource |
| [azurerm_app_service_custom_hostname_binding.datastore](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/app_service_custom_hostname_binding) | resource |
| [azurerm_app_service_managed_certificate.controller](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/app_service_managed_certificate) | resource |
| [azurerm_app_service_managed_certificate.datastore](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/app_service_managed_certificate) | resource |
| [azurerm_app_service_virtual_network_swift_connection.controller](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/app_service_virtual_network_swift_connection) | resource |
| [azurerm_dns_cname_record.controller](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/dns_cname_record) | resource |
| [azurerm_dns_cname_record.datastore](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/dns_cname_record) | resource |
| [azurerm_dns_ns_record.rookout](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/dns_ns_record) | resource |
| [azurerm_dns_txt_record.controller](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/dns_txt_record) | resource |
| [azurerm_dns_txt_record.datastore](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/dns_txt_record) | resource |
| [azurerm_dns_zone.sub_domain](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/dns_zone) | resource |
| [azurerm_linux_web_app.controller](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/linux_web_app) | resource |
| [azurerm_linux_web_app.datastore](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/linux_web_app) | resource |
| [azurerm_private_dns_zone.private_zone](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.dnszonelink](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.controller](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.datastore](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/private_endpoint) | resource |
| [azurerm_public_ip.vpn](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rookout](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/resource_group) | resource |
| [azurerm_service_plan.controller](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/service_plan) | resource |
| [azurerm_subnet.app_serivce](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/subnet) | resource |
| [azurerm_subnet.gateway](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/subnet) | resource |
| [azurerm_subnet.private_endpoint_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/subnet) | resource |
| [azurerm_virtual_network.rookout](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_gateway.vpn](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/virtual_network_gateway) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/data-sources/client_config) | data source |
| [azurerm_dns_zone.selected](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/data-sources/dns_zone) | data source |
| [azurerm_resource_group.selected](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/data-sources/resource_group) | data source |
| [azurerm_virtual_network.selected](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_vnet"></a> [create\_vnet](#input\_create\_vnet) | Flag of creation of virtual network | `bool` | `true` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain of your applicaiton | `string` | `""` | no |
| <a name="input_domain_resource_group"></a> [domain\_resource\_group](#input\_domain\_resource\_group) | Resource group of domain hosted zone | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | This variable used for namespacing and renaming resources | `string` | `"test"` | no |
| <a name="input_existing_resource_group_name"></a> [existing\_resource\_group\_name](#input\_existing\_resource\_group\_name) | Resource group of provided virtual network | `string` | `""` | no |
| <a name="input_existing_vnet_name"></a> [existing\_vnet\_name](#input\_existing\_vnet\_name) | Provided virtual network name, where rookout app service will be deployed | `string` | `""` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | Flag to switch the deployment to be internal | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | Location of resources | `string` | `"northeurope"` | no |
| <a name="input_private_endpoint_subnet_cidr"></a> [private\_endpoint\_subnet\_cidr](#input\_private\_endpoint\_subnet\_cidr) | CIDR of private endpoint, for internal deployment | `string` | `"10.10.0.64/26"` | no |
| <a name="input_rookout_token"></a> [rookout\_token](#input\_rookout\_token) | Rookout's org token | `string` | n/a | yes |
| <a name="input_subnet_app_serivce_cidr"></a> [subnet\_app\_serivce\_cidr](#input\_subnet\_app\_serivce\_cidr) | vnet subnets | `string` | `"10.10.0.0/26"` | no |
| <a name="input_vnet_cidr"></a> [vnet\_cidr](#input\_vnet\_cidr) | CIDR of vnet resource to be created | `string` | `"10.10.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_controller_deafult_hostname"></a> [controller\_deafult\_hostname](#output\_controller\_deafult\_hostname) | n/a |
| <a name="output_controller_dns"></a> [controller\_dns](#output\_controller\_dns) | n/a |
| <a name="output_datastore_deafult_hostname"></a> [datastore\_deafult\_hostname](#output\_datastore\_deafult\_hostname) | n/a |
| <a name="output_datastore_dns"></a> [datastore\_dns](#output\_datastore\_dns) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
<!-- END_TF_DOCS -->

## Developers
We're using [Release Please](https://github.com/googleapis/release-please) for releasing the module. Please make sure you follow the [guidelines for commit messages](https://github.com/googleapis/release-please#how-should-i-write-my-commits) 

