locals {
  postgres_dbs = {
    event    = "eventdb"
    user     = "userdb"
    booking  = "bookingdb"
    payment  = "paymentdb"
  }
}

resource "azurerm_container_app" "postgres" {
  for_each = local.postgres_dbs

  name                         = "postgres-${each.key}"
  resource_group_name          = azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.env.id
  revision_mode                = "Single"

  template {
    container {
      name   = "postgres"
      image  = "postgres:17-alpine"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "POSTGRES_DB"
        value = each.value
      }

      env {
        name  = "POSTGRES_USER"
        value = "postgres"
      }

      env {
        name  = "POSTGRES_PASSWORD"
        value = "postgres"
      }
    }

    min_replicas = 1
    max_replicas = 1
  }

  ingress {
    external_enabled = false
    target_port      = 5432
    traffic_weight {
  latest_revision = true
  percentage      = 100
}
  }
}