locals {
  tags = {
    terraform   = true
    Environment = var.environment
    Service     = "rookout"
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rookout" {
  count = var.existing_resource_group_name == "" ? 0 : 1

  name     = "${var.environment}-rookout-ResourceGroup"
  location = var.location

  tags = local.tags
}

data "azurerm_resource_group" "selected" {
  count = var.existing_resource_group_name == "" ? 1 : 0

  name = var.existing_resource_group_name
}

resource "azurerm_service_plan" "controller" {
  name                = "${var.environment}-rookout-controller-plan"
  location            = var.existing_resource_group_name == "" ? azurerm_resource_group.rookout[0].location : azurerm_resource_group.selected[0].location
  resource_group_name = var.existing_resource_group_name == "" ? azurerm_resource_group.rookout[0].name : azurerm_resource_group.selected[0].name
  os_type             = "Linux"
  sku_name            = "P2v2"
}

