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

      env {
        name  = "NGINX_HOST"
        value = "localhost"
      }

      env {
        name  = "NGINX_PORT"
        value = "80"
      }

      env {
        name  = "EVENT_SERVICE_URL"
        value = "http://event-service:3001"
      }

      env {
        name  = "USER_SERVICE_URL"
        value = "http://user-service:3002"
      }

      env {
        name  = "BOOKING_SERVICE_URL"
        value = "http://booking-service:3003"
      }

      env {
        name  = "PAYMENT_SERVICE_URL"
        value = "http://payment-service:3004"
      }
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
