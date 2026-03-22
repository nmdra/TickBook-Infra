resource "azurerm_container_app" "services" {
  for_each = var.services

  name                         = each.key
  resource_group_name          = azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.env.id
    revision_mode                = "Single"

  template {
    container {
      name   = each.key
      image  = "${var.registry_name}.azurecr.io/${each.key}:${var.image_tag}"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "PORT"
        value = tostring(each.value.port)
      }

      env {
        name  = "DB_HOST"
        value = "postgres-${replace(each.key, "-service", "")}"
      }

      env {
        name  = "DB_NAME"
        value = each.value.db
      }

      dynamic "env" {
        for_each = local.common_env
        content {
          name  = env.key
          value = env.value
        }
      }

      dynamic "env" {
        for_each = lookup(local.service_env, each.key, {})
        content {
          name  = env.key
          value = env.value
        }
      }
    }

    min_replicas = 0
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
