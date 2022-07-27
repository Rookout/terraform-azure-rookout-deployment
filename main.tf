data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

provider "azurerm" {
  features {}
}

locals {
  resource_group_name     = var.create_resource_group ? azurerm_resource_group.rookout[0].name : data.azurerm_resource_group.provided[0].name
  resource_group_location = var.create_resource_group ? azurerm_resource_group.rookout[0].location : data.azurerm_resource_group.provided[0].location
  tags = {
    terraform   = true
    Environment = var.environment
    Service     = "rookout"
  }
}

data "azurerm_resource_group" "provided" {
  count = var.create_resource_group ? 0 : 1

  name = var.resource_group_name

}

resource "azurerm_resource_group" "rookout" {
  count = var.create_resource_group ? 1 : 0

  name     = "${var.environment}-rookout-resource-group"
  location = var.location

  tags = local.tags

}