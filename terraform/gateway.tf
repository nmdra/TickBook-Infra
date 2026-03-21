resource "azurerm_container_app" "gateway" {
  name                         = "nginx-gateway"
  resource_group_name          = azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.env.id
revision_mode                = "Single"

  template {
    container {
      name   = "nginx"
      image  = "${var.registry_name}.azurecr.io/nginx-gateway:${var.image_tag}"
      cpu    = 0.25
      memory = "0.5Gi"
    }

    min_replicas = 0
    max_replicas = 1
  }

  ingress {
    external_enabled = true
    target_port      = 80
    traffic_weight {
  latest_revision = true
  percentage      = 100
}
  }
}