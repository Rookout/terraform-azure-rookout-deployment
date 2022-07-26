
locals {
  demo_settings = {
    container_name   = "rookout-tutorial-python"
    container_cpu    = 0.5
    container_memory = 0.5
    container_port   = 5000
    app_gateway_port = 443
  }

  demo_environment_variables = merge(
    {
      ROOKOUT_CONTROLLER_HOST = "ws://${azurerm_container_group.controller.ip_address}"
      ROOKOUT_CONTROLLER_PORT = local.controller_settings.container_port
      ROOKOUT_REMOTE_ORIGIN   = "https://github.com/Rookout/tutorial-python.git"
      ROOKOUT_COMMIT          = "HEAD"
    },
    var.additional_demo_app_env_vars
  )

  demo_secure_environment_variables = {
    ROOKOUT_TOKEN = var.rookout_token
  }

}


resource "azurerm_container_group" "demo" {
  count = var.deploy_demo_app ? 1 : 0

  name                = local.demo_settings.container_name
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  ip_address_type     = "Private"
  os_type             = "Linux"
  network_profile_id  = azurerm_network_profile.private.id

  container {
    name   = local.demo_settings.container_name
    image  = "rookout/tutorial-python:latest"
    cpu    = local.demo_settings.container_cpu
    memory = local.demo_settings.container_memory

    environment_variables        = local.demo_environment_variables
    secure_environment_variables = local.demo_secure_environment_variables

    ports {
      port     = local.demo_settings.container_port
      protocol = "TCP"
    }

    liveness_probe {
      exec              = ["wget http://localhost:5000/ -O /dev/null || exit 1"]
      period_seconds    = 30
      failure_threshold = 3
      success_threshold = 3
      timeout_seconds   = 5
    }
  }

  tags = local.tags

}