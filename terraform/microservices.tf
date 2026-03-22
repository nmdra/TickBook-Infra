resource "azurerm_container_app" "services" {
  for_each                     = var.services
  name                         = each.key
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
    container {
      name   = each.key
      image  = "${var.registry_name}/${var.image_path}/${each.key}:${var.image_tag}"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "PORT"
        value = tostring(each.value.port)
      }
      env {
        name  = "DB_HOST"
        value = "postgres-${replace(each.key, "-service", "")}" # fixed
      }
      env {
        name  = "DB_NAME"
        value = each.value.db
      }

      dynamic "env" {
        for_each = local.common_env
        content {
          name  = upper(env.key)
          value = env.value
        }
      }

      dynamic "env" {
        for_each = lookup(local.service_env, each.key, {})
        content {
          name  = upper(env.key)
          value = env.value
        }
      }
    }

    min_replicas = 1
    max_replicas = 1
  }

  ingress {
    external_enabled = false
    target_port      = each.value.port
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}