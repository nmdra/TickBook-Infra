locals {
  common_env = {
    DB_USER     = var.postgres_admin_user
    DB_PASSWORD = var.postgres_admin_password
    DB_PORT     = "5432"
    KAFKA_BROKERS = "kafka:29092"
  }
}
