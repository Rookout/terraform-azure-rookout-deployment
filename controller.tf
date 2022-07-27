locals {
  controller_settings = {
    container_name    = "rookout-controller"
    task_cpu          = var.controller_resource.cpu
    task_memory       = var.controller_resource.memory
    onprem_enabled    = true
    dop_no_ssl_verify = false
    server_mode       = "PLAIN"
    container_cpu     = var.controller_resource.cpu
    container_memory  = var.controller_resource.memory
    container_port    = 7488
    app_gateway_port  = 443
  }

  controller_environment_variables = merge(
    {
      ROOKOUT_DOP_NO_SSL_VERIFY      = local.controller_settings.dop_no_ssl_verify
      ONPREM_ENABLED                 = var.deploy_datastore ? local.controller_settings.onprem_enabled : false
      ROOKOUT_CONTROLLER_SERVER_MODE = local.controller_settings.server_mode
      ROOKOUT_ENFORCE_TOKEN          = "true"
    },
    var.additional_controller_env_vars
  )

  controller_secure_environment_variables = {
    ROOKOUT_TOKEN = var.rookout_token
  }

}

resource "azurerm_container_group" "controller" {
  name                = local.controller_settings.container_name
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  ip_address_type     = "Private"
  os_type             = "Linux"
  network_profile_id  = azurerm_network_profile.private.id

  container {
    name   = local.controller_settings.container_name
    image  = "rookout/controller:latest"
    cpu    = local.controller_settings.container_cpu
    memory = local.controller_settings.container_memory

    environment_variables        = local.controller_environment_variables
    secure_environment_variables = local.controller_secure_environment_variables

    ports {
      port     = local.controller_settings.container_port
      protocol = "TCP"
    }

    liveness_probe {
      exec              = ["wget http://localhost:4009/healthz -O /dev/null || exit 1"]
      period_seconds    = 30
      failure_threshold = 3
      success_threshold = 3
      timeout_seconds   = 5
    }
  }

  tags = local.tags

}