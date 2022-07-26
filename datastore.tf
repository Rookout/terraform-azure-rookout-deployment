
locals {
  datastore_settings = {
    container_name         = "rookout-datastore"
    task_cpu               = var.datastore_resource.cpu
    task_memory            = var.datastore_resource.memory
    onprem_enabled         = true
    dop_no_ssl_verify      = false
    server_mode            = "PLAIN"
    container_cpu          = var.datastore_resource.cpu
    container_memory       = var.datastore_resource.memory
    container_port         = 8080
    app_gateway_port       = 443
    storage_size           = 21
    datastore_in_memory_db = true
  }

  datastore_environment_variables = merge(
    {
      ROOKOUT_DOP_IN_MEMORY_DB = local.datastore_settings.datastore_in_memory_db
      ROOKOUT_DOP_PORT         = local.datastore_settings.container_port
      ROOKOUT_DOP_SERVER_MODE  = local.datastore_settings.server_mode
    },
    var.additional_datastore_env_vars
  )

  datastore_secure_environment_variables = {
    ROOKOUT_TOKEN = var.rookout_token
  }

}

resource "azurerm_container_group" "datastore" {
  count = var.deploy_datastore ? 1 : 0

  name                = local.datastore_settings.container_name
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  ip_address_type     = "Private"
  os_type             = "Linux"
  network_profile_id  = azurerm_network_profile.private.id

  container {
    name   = local.datastore_settings.container_name
    image  = "rookout/data-on-prem:latest"
    cpu    = local.datastore_settings.container_cpu
    memory = local.datastore_settings.container_memory

    environment_variables        = local.datastore_environment_variables
    secure_environment_variables = local.datastore_secure_environment_variables

    ports {
      port     = local.datastore_settings.container_port
      protocol = "TCP"
    }

    liveness_probe {
      exec = ["wget http://localhost:4009/healthz -O /dev/null || exit 1"]

      period_seconds    = 30
      failure_threshold = 3
      success_threshold = 3
      timeout_seconds   = 5
    }
  }

  tags = local.tags

}