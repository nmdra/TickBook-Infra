resource "azurerm_container_app" "redis" {
  name                         = "redis"
  resource_group_name          = azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.env.id
revision_mode                = "Single"

  template {
    container {
      name   = "redis"
      image  = "redis:7-alpine"
      cpu    = 0.25
      memory = "0.5Gi"
    }

    min_replicas = 1
    max_replicas = 1
  }

  ingress {
    external_enabled = false
    target_port      = 6379
    traffic_weight {
  latest_revision = true
  percentage      = 100
}
  }
}