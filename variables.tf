##Global variables
variable "environment" {
  type        = string
  default     = "rookout"
  description = "Environment name"
}
variable "location" {
  type        = string
  default     = ""
  description = "Azure location, using providers location as default"
}
variable "resource_group_name" {
  type        = string
  default     = ""
  description = "Existing Azure Resource Group name, if not set default rookout resource group will be created."
}
variable "create_resource_group" {
  type        = bool
  default     = true
  description = "whether create a Azure Resource Group or use existing one. resource_group_name should be set."
}


## DNS
variable "domain_name" {
  type    = string
  default = ""
  # validation {
  #   condition     = length(var.domain_name) > 0
  #   error_message = "Domain not provided"
  # }
  description = "DNS domain which sub"
}


## Rookout variables
variable "deploy_datastore" {
  type        = bool
  default     = true
  description = "(Optional) If true will deploy demo Rookout's datastore locally"
}
variable "deploy_demo_app" {
  type        = bool
  default     = false
  description = "(Optional) If true will deploy demo flask application to start debuging"
}

variable "controller_resource" {
  type = map(any)
  default = {
    cpu    = 2,
    memory = 4
  }
  description = "Rookout's onprem controller resource map"
}

variable "datastore_resource" {
  type = map(any)
  default = {
    cpu    = 2,
    memory = 4
  }
  description = "Rookout's onprem datastore resource map"
}
variable "rookout_token" {
  type = string
  validation {
    condition     = length(var.rookout_token) == 64
    error_message = "Rookout token have to be 64 characters in length."
  }
  description = "Rookout token"
}

## VNET variables. 
variable "create_vnet" {
  type    = bool
  default = true
}

variable "vnet_id" {
  type        = string
  description = "VNET id should be passed only if create_vnet = false"
  default     = ""
}

variable "vnet_cidr" {
  type    = string
  default = "172.30.0.0/23"
}

variable "vpc_avilability_zones" {
  type    = list(string)
  default = ["eu-west-1a", "eu-west-1b"]
}

variable "backend_subnets" {
  type    = list(string)
  default = ["172.30.0.0/27"]
}

variable "frontend_subnets" {
  type    = list(string)
  default = ["172.30.1.0/24"]
}

## Application Gateway
variable "deploy_app_gw" {
  type        = bool
  default     = true
  description = "Radio button to not deploy Application Gateway for Container Instances."
}

variable "demo_app_controller_host" {
  type        = string
  default     = ""
  description = "Host which the demo rook connect to controller using WebSocket"
}

variable "internal_controller_app_gw" {
  type        = bool
  default     = false
  description = "If domain provided, switching in on will make controller be reachable internaly only"
}

## ENV vars
# {
#     "EXAMPLE_ENV" = "changethisvalue"
# }
variable "additional_controller_env_vars" {
  type        = any
  description = "Additional env variables of contorller, configure as map of key=values"
  default     = {}
}

variable "additional_datastore_env_vars" {
  type        = any
  description = "Additional env variables of contorller, configure as map of key=values"
  default     = {}
}

variable "additional_demo_app_env_vars" {
  type        = any
  description = "Additional env variables of contorller, configure as map of key=values"
  default     = {}
}

## Self managed Key Vault certificates
variable "key_vault_name" {
  type        = string
  default     = ""
  description = "Key Vault containing certificates name. "
}

variable "datastore_vault_certificate_id" {
  type        = string
  default     = ""
  description = "ID of pre-imported SSL certificate to Key Vault for Rookouts datastore public access"
}

variable "controller_vault_certificate_id" {
  type        = string
  default     = ""
  description = "ID of pre-imported SSL certificate to Key Vault for Rookouts controller public access, if datastore datastore_vault_certificate_id provided controller app_gw will be internal"
}