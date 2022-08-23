resource "azurerm_virtual_network" "rookout" {
  count = var.create_vnet ? 1 : 0

  name                = "${var.environment}-rookout-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.rookout.name
  address_space       = [var.vnet_cidr]

  tags = local.tags
}

data "azurerm_virtual_network" "selected" {
  count = var.create_vnet ? 0 : 1

  name                = var.existing_vnet_name
  resource_group_name = var.existing_vnet_resource_group
}

resource "azurerm_subnet" "app_serivce" {
  name                 = "${var.environment}-rookout-app-serivce-subnet"
  resource_group_name  = azurerm_resource_group.rookout.name
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
  subnet_id      = azurerm_subnet.app_serivce.id
}