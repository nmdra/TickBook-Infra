resource "azurerm_container_app" "gateway" {
  name                         = "nginx-gateway"
  resource_group_name          = data.azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.env.id
  revision_mode                = "Single"

  registry {
    server               = var.registry_name
    username             = data.azurerm_container_registry.acr.admin_username
    password_secret_name = "acr-password"
  }

  secret {
    name  = "acr-password"
    value = data.azurerm_container_registry.acr.admin_password
  }

  template {
    min_replicas = 1
    max_replicas = 1

    container {
      name   = "nginx"
      image  = "${var.registry_name}/${var.image_path}/nginx-gateway:${var.image_tag}"
      cpu    = 0.25
      memory = "0.5Gi"

      dynamic "env" {
        for_each = local.gateway_env
        content {
          name  = upper(env.key)
          value = env.value
        }
      }
    }
  }

  ingress {
    external_enabled           = true
    target_port                = 80
    transport                  = "http"
    allow_insecure_connections = false

    cors {
      allowed_origins           = ["*"]
      allowed_methods           = ["GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"]
      allowed_headers           = ["*"]
      max_age_in_seconds        = 3600
      allow_credentials_enabled = false
    }

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  lifecycle {
    ignore_changes = [
      tags,
      template[0].container[0].args,
      template[0].container[0].command,
    ]
  }
}