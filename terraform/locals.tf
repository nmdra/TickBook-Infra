locals {
  common_env = {
    DB_USER     = "postgres"
    DB_PASSWORD = "postgres"
    DB_PORT     = "5432"
    KAFKA_BROKERS = "kafka:29092"
  }
}