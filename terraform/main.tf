resource "azurerm_log_analytics_workspace" "log" {
  name                = "aca-logs"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
}

resource "azurerm_container_app_environment" "env" {
  name                       = "aca-env"
  location                   = var.location
  resource_group_name        = data.azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id
}

resource "azurerm_container_app" "postgres" {
  for_each = local.postgres_dbs

  name                         = "postgres-${each.key}"
  resource_group_name          = data.azurerm_resource_group.rg.name
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
        value = var.postgres_user
      }
      env {
        name  = "POSTGRES_PASSWORD"
        value = var.postgres_password
      }
    }

    min_replicas = 1
    max_replicas = 1
  }

  ingress {
    external_enabled = false
    target_port      = 5432
    exposed_port     = 5432
    transport        = "tcp"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

resource "azurerm_container_app" "redis" {
  name                         = "redis"
  resource_group_name          = data.azurerm_resource_group.rg.name
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
    exposed_port     = 6379
    transport        = "tcp"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

resource "azurerm_container_app" "kafka" {
  name                         = "kafka"
  resource_group_name          = data.azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.env.id
  revision_mode                = "Single"

  template {
    container {
      name   = "kafka"
      image  = "confluentinc/cp-kafka:7.6.0"
      cpu    = 0.5
      memory = "1Gi"

      env {
        name  = "KAFKA_NODE_ID"
        value = "1"
      }
      env {
        name  = "KAFKA_PROCESS_ROLES"
        value = "broker,controller"
      }
      env {
        name  = "KAFKA_CONTROLLER_LISTENER_NAMES"
        value = "CONTROLLER"
      }
      env {
        name  = "KAFKA_LISTENERS"
        value = "PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093"
      }
      env {
        name  = "KAFKA_ADVERTISED_LISTENERS"
        value = "PLAINTEXT://kafka:9092" # ACA resolves by app name
      }
      env {
        name  = "KAFKA_LISTENER_SECURITY_PROTOCOL_MAP"
        value = "PLAINTEXT:PLAINTEXT,CONTROLLER:PLAINTEXT"
      }
      env {
        name  = "KAFKA_CONTROLLER_QUORUM_VOTERS"
        value = "1@localhost:9093"
      }
      env {
        name  = "KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR"
        value = "1"
      }
      env {
        name  = "KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR"
        value = "1"
      }
      env {
        name  = "KAFKA_TRANSACTION_STATE_LOG_MIN_ISR"
        value = "1"
      }
      env {
        name  = "KAFKA_AUTO_CREATE_TOPICS_ENABLE"
        value = "true"
      }
      env {
        name  = "CLUSTER_ID"
        value = "MkU3OEVBNTcwNTJENDM2Qk"
      }
    }

    min_replicas = 1
    max_replicas = 1
  }

  ingress {
    external_enabled = false
    target_port      = 9092
    transport        = "tcp"
    exposed_port     = 9092
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

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

  depends_on = [
    azurerm_container_app.postgres,
    azurerm_container_app.redis,
    azurerm_container_app.kafka,
  ]

  ingress {
    external_enabled = false
    target_port      = each.value.port
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

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
      allowed_origins           = var.allowed_origins
      allowed_methods           = ["GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"]
      allowed_headers           = ["*"]
      max_age_in_seconds        = 3600
      allow_credentials_enabled = true
    }

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  depends_on = [
    azurerm_container_app.services,
  ]

  lifecycle {
    ignore_changes = [
      tags,
      template[0].container[0].args,
      template[0].container[0].command,
    ]
  }
}
