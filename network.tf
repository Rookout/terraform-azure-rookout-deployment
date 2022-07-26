resource "azurerm_virtual_network" "rookout" {
  count = var.create_vnet ? 1 : 0

  name                = "${var.environment}-rookout"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  address_space       = [var.vnet_cidr]

  tags = local.tags

}

resource "azurerm_subnet" "frontend" {
  count = var.create_vnet ? 1 : 0

  name                 = "${var.environment}-rookout-frontend"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.rookout[0].name
  address_prefixes     = var.frontend_subnets

  depends_on = [azurerm_virtual_network.rookout]

}

resource "azurerm_subnet" "backend" {
  count = var.create_vnet ? 1 : 0

  name                 = "${var.environment}-rookout-backend"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.rookout[0].name
  address_prefixes     = var.backend_subnets

  delegation {
    name = "delegation"

    service_delegation {
      name = "Microsoft.ContainerInstance/containerGroups"
      actions = [
        # "Microsoft.Network/virtualNetworks/subnets/join/action", 
        # "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }

  depends_on = [azurerm_virtual_network.rookout]

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
  count = 0 #var.deploy_app_gw && var.internal_controller_app_gw == false ? 1 : 0

  name                = "${var.environment}-rookout-controller-pip"
  sku                 = "Standard"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  allocation_method   = "Static"
  domain_name_label   = "${var.environment}-rookout-controller"

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
      subnet_id = var.create_vnet ? azurerm_subnet.backend[0].id : var.backend_subnets[0]
    }
  }

  tags = local.tags

}