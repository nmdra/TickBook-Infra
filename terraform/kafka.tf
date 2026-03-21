resource "azurerm_container_app" "kafka" {
  name                         = "kafka"
  resource_group_name          = azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.env.id
  revision_mode                = "Single"

  template {
    container {
      name   = "kafka"
      image  = "confluentinc/cp-kafka:8.2.0"
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
        name  = "KAFKA_CONTROLLER_QUORUM_VOTERS"
        value = "1@kafka:9093"
      }

      env {
        name  = "KAFKA_LISTENERS"
        value = "PLAINTEXT://0.0.0.0:29092,CONTROLLER://0.0.0.0:9093"
      }

      env {
        name  = "KAFKA_ADVERTISED_LISTENERS"
        value = "PLAINTEXT://kafka:29092"
      }

      env {
        name  = "KAFKA_LISTENER_SECURITY_PROTOCOL_MAP"
        value = "PLAINTEXT:PLAINTEXT,CONTROLLER:PLAINTEXT"
      }

      env {
        name  = "KAFKA_CONTROLLER_LISTENER_NAMES"
        value = "CONTROLLER"
      }

      env {
        name  = "KAFKA_INTER_BROKER_LISTENER_NAME"
        value = "PLAINTEXT"
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
        name  = "CLUSTER_ID"
        value = "MkU3OEVBNTcwNTJENDM2Qk"
      }
    }

    min_replicas = 1
    max_replicas = 1
  }

  ingress {
    external_enabled = false
    target_port      = 29092

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}