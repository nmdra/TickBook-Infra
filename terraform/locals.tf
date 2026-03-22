locals {
  common_env = {
    DB_USER       = var.postgres_user
    DB_PASSWORD   = var.postgres_password
    DB_PORT       = "5432"
    KAFKA_BROKERS = "kafka:29092"
  }

  service_env = {
    event-service = {
      REDIS_HOST = "redis"
      REDIS_PORT = "6379"
    }
    user-service = {
      DATABASE_URL           = format("postgresql://%s:%s@postgres-user:5432/userdb?sslmode=disable", var.postgres_user, var.postgres_password)
      JWT_SECRET             = var.jwt_secret
      JWT_REFRESH_SECRET     = var.jwt_refresh_secret
      GOOGLE_CLIENT_ID       = var.google_client_id
      GOOGLE_CLIENT_SECRET   = var.google_client_secret
      GOOGLE_REDIRECT_URI    = var.google_redirect_uri
      FRONTEND_SUCCESS_URL   = var.frontend_success_url
      FRONTEND_DASHBOARD_URL = var.frontend_dashboard_url
      BOOKING_SERVICE_URL    = "http://booking-service:3003"
      PAYMENT_SERVICE_URL    = "http://payment-service:3004"
    }
    booking-service = {
      EVENT_SERVICE_URL = "http://event-service:3001"
      USER_SERVICE_URL  = "http://user-service:3002"
    }
    payment-service = {
      BOOKING_SERVICE_URL   = "http://booking-service:3003"
      STRIPE_SECRET_KEY     = var.stripe_secret_key
      STRIPE_WEBHOOK_SECRET = var.stripe_webhook_secret
      STRIPE_CURRENCY       = var.stripe_currency
      STRIPE_SUCCESS_URL    = var.stripe_success_url
      STRIPE_CANCEL_URL     = var.stripe_cancel_url
    }
  }
}
