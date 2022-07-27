module "vnet" {
  count   = var.create_vnet ? 1 : 0
  source  = "Azure/vnet/azurerm"

  vnet_name           = "${var.environment}-rookout"
  vnet_location       = local.resource_group_location
  resource_group_name = local.resource_group_name
  address_space       = [var.vnet_cidr]
  subnet_prefixes     = concat(var.backend_subnets, var.frontend_subnets)
  subnet_names        = ["backend", "frontend"]

  subnet_delegation = {
    backend = {
      "Microsoft.ContainerInstance" = {
        service_name    = "Microsoft.ContainerInstance/containerGroups"
        service_actions = [
          "Microsoft.Network/virtualNetworks/subnets/action",
        ]
      }
    }
  }

  tags = local.tags

  depends_on = [local.resource_group_name]

}

locals {
  backend_subnet_id  = var.create_vnet ? module.vnet[0].vnet_subnets[0] : var.backend_subnets[0]
  frontend_subnet_id = var.create_vnet ? module.vnet[0].vnet_subnets[1] : var.frontend_subnets[0]
}

resource "azurerm_public_ip" "datastore" {
  count = var.deploy_app_gw && var.deploy_datastore ? 1 : 0

  name                = "${var.environment}-rookout-datastore-pip"
  sku                 = "Standard"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  allocation_method   = "Static"
  domain_name_label   = "${var.environment}-rookout-datastore"

  tags = local.tags
}

resource "azurerm_public_ip" "controller" {
  count = var.deploy_app_gw && !var.internal_controller_app_gw ? 1 : 0

  name                = "${var.environment}-rookout-controller-pip"
  sku                 = "Standard"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  allocation_method   = "Static"
  domain_name_label   = "${var.environment}-rookout-controller"

  tags = local.tags
}

resource "azurerm_public_ip" "demo" {
  count = var.deploy_app_gw && var.deploy_demo_app ? 1 : 0

  name                = "${var.environment}-rookout-demo-pip"
  sku                 = "Basic"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.environment}-rookout-demo"

  tags = local.tags
}

resource "azurerm_network_profile" "private" {
  name                = "${var.environment}-rookout-private"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name

  container_network_interface {
    name = "${var.environment}-rookout-nic"

    ip_configuration {
      name      = "${var.environment}-rookout-backend"
      subnet_id = var.create_vnet ? local.backend_subnet_id : var.backend_subnets[0]
    }
  }

  tags = local.tags

}