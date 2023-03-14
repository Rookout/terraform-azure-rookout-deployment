resource "azurerm_virtual_network" "rookout" {
  count = var.create_vnet ? 1 : 0

  name                = "${var.environment}-rookout-vnet"
  location            = var.location
  resource_group_name = var.existing_resource_group_name == "" ? azurerm_resource_group.rookout[0].name : data.azurerm_resource_group.selected[0].name
  address_space       = [var.vnet_cidr]

  tags = local.tags
}

data "azurerm_virtual_network" "selected" {
  count = var.create_vnet ? 0 : 1

  name                = var.existing_vnet_name
  resource_group_name = var.existing_vnet_resource_group_name
}

data "azurerm_subnet" "app_service_selected" {
  count = !var.create_vnet && var.subnet_app_serivce_name == "" ? 0 : 1

  name                 = var.subnet_app_serivce_name
  virtual_network_name = data.azurerm_virtual_network.selected[0].name
  resource_group_name  = var.existing_vnet_resource_group_name
}

resource "azurerm_subnet" "app_serivce" {
  count = var.subnet_app_serivce_name == "" ? 1 : 0

  name                 = "${var.environment}-rookout-app-serivce-subnet"
  resource_group_name  = var.existing_vnet_resource_group_name == "" ? azurerm_resource_group.rookout[0].name : var.existing_vnet_resource_group_name
  virtual_network_name = var.create_vnet ? azurerm_virtual_network.rookout[0].name : data.azurerm_virtual_network.selected[0].name
  address_prefixes     = [var.subnet_app_serivce_cidr]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

}

resource "azurerm_app_service_virtual_network_swift_connection" "controller" {

  app_service_id = azurerm_linux_web_app.controller.id
  subnet_id      = var.subnet_app_serivce_name == "" ? azurerm_subnet.app_serivce[0].id : data.azurerm_subnet.app_service_selected[0].id
}