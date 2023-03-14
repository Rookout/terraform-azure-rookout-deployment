############ GLOBALS ############
variable "environment" {
  type        = string
  default     = "test"
  description = "This variable used for namespacing and renaming resources"
}

variable "location" {
  type        = string
  default     = "northeurope"
  description = "Location of resources"
}

############ NETWORK ############

variable "vnet_cidr" {
  type        = string
  default     = "10.10.0.0/16"
  description = "CIDR of vnet resource to be created"
}

variable "create_vnet" {
  type        = bool
  default     = true
  description = "Flag of creation of virtual network"
}

variable "existing_vnet_name" {
  type        = string
  default     = ""
  description = "Provided virtual network name, where rookout app service will be deployed"
}

variable "existing_vnet_resource_group_name" {
  type        = string
  default     = ""
  description = "Resource group of provided virtual network"
}

variable "subnet_app_service_cidr" {
  type        = string
  default     = "10.10.0.0/26"
  description = "vnet subnets"
}

variable "private_endpoint_subnet_cidr" {
  type        = string
  default     = "10.10.0.64/26"
  description = "CIDR of private endpoint, for internal deployment"
}

variable "subnet_app_service_name" {
  type        = string
  default     = ""
  description = "App Service delegated subnet, Minimum CIDR mask is 26 bits, should be in existing vnet resource group"
}

variable "private_endpoint_subnet_name" {
  type        = string
  default     = ""
  description = "Private endpoints subnet, used for internal deployment, Minimum CIDR mask is 26 bits, should be in existing vnet resource group"
}

############ ROOKOUT ############

variable "rookout_token" {
  type        = string
  description = "Rookout's org token"
}

variable "domain_name" {
  type        = string
  default     = ""
  description = "Domain of your applicaiton"
}

variable "domain_resource_group" {
  type        = string
  default     = ""
  description = "Resource group of domain hosted zone"
}

variable "internal" {
  type        = bool
  default     = false
  description = "Flag to switch the deployment to be internal"
}

variable "existing_resource_group_name" {
  type        = string
  default     = ""
  description = "Resource group of rookout deployment, if not existing, will create one that named 'ENV-rookout-ResourceGroup'"
}