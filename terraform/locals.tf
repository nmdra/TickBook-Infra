locals {
  postgres_dbs = {
    event   = "eventdb"
    user    = "userdb"
    booking = "bookingdb"
    payment = "paymentdb"
  }

  internal_domain = "internal.${azurerm_container_app_environment.env.default_domain}"

  common_env = {
    DB_PORT       = "5432"
    DB_USER       = var.postgres_user
    DB_PASSWORD   = var.postgres_password
    KAFKA_BROKERS = "kafka:9092"
  }

  service_env = {
    event-service = {
      REDIS_HOST = "redis"
      REDIS_PORT = "6379"
    }
    user-service = {
      DATABASE_URL           = format("postgresql://%s:%s@postgres-user:5432/userdb?sslmode=%s", var.postgres_user, var.postgres_password, var.postgres_sslmode)
      KAFKA_BROKERS          = "kafka:9092"
      JWT_SECRET             = var.jwt_secret
      JWT_REFRESH_SECRET     = var.jwt_refresh_secret
      GOOGLE_CLIENT_ID       = var.google_client_id
      GOOGLE_CLIENT_SECRET   = var.google_client_secret
      GOOGLE_REDIRECT_URI    = var.google_redirect_uri
      FRONTEND_SUCCESS_URL   = var.frontend_success_url
      FRONTEND_DASHBOARD_URL = var.frontend_dashboard_url
      BOOKING_SERVICE_URL    = "http://booking-service.${local.internal_domain}"
      PAYMENT_SERVICE_URL    = "http://payment-service.${local.internal_domain}"
    }
    booking-service = {
      KAFKA_PAYMENTS_TOPIC = "payments"
      KAFKA_PAYMENTS_GROUP = "booking-service"
      EVENT_SERVICE_URL    = "http://event-service.${local.internal_domain}"
      USER_SERVICE_URL     = "http://user-service.${local.internal_domain}"
    }
    payment-service = {
      KAFKA_RECONNECT_INTERVAL_MS = "15000"
      KAFKA_PAYMENTS_TOPIC        = "payments"
      BOOKING_SERVICE_URL         = "http://booking-service.${local.internal_domain}"
      STRIPE_SECRET_KEY           = var.stripe_secret_key
      STRIPE_WEBHOOK_SECRET       = var.stripe_webhook_secret
      STRIPE_CURRENCY             = var.stripe_currency
      STRIPE_SUCCESS_URL          = var.stripe_success_url
      STRIPE_CANCEL_URL           = var.stripe_cancel_url
    }
  }

  gateway_env = {
    NGINX_HOST          = var.nginx_host
    NGINX_PORT          = tostring(var.nginx_port)
    EVENT_SERVICE_URL   = "https://event-service.${local.internal_domain}" # http not https
    USER_SERVICE_URL    = "https://user-service.${local.internal_domain}"
    BOOKING_SERVICE_URL = "https://booking-service.${local.internal_domain}"
    PAYMENT_SERVICE_URL = "https://payment-service.${local.internal_domain}"
  }
}
