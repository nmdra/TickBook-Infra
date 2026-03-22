locals {
  common_env = {
    DB_USER     = "postgres"
    DB_PASSWORD = "postgres"
    DB_PORT     = "5432"
    KAFKA_BROKERS = "kafka:29092"
  }

  service_env = {
    event-service = {
      REDIS_HOST = "redis"
      REDIS_PORT = "6379"
    }
    user-service = {
      DATABASE_URL          = "postgresql://postgres:postgres@postgres-user:5432/userdb?sslmode=disable"
      JWT_SECRET            = "demo-secret-change-in-production"
      JWT_REFRESH_SECRET    = "demo-refresh-secret-change-in-production"
      GOOGLE_CLIENT_ID      = "your-google-client-id"
      GOOGLE_CLIENT_SECRET  = "your-google-client-secret"
      GOOGLE_REDIRECT_URI   = "http://localhost:3002/api/users/auth/google/callback"
      FRONTEND_SUCCESS_URL  = "http://localhost:3002/google-auth-success.html"
      FRONTEND_DASHBOARD_URL = "http://localhost:3000/dashboard"
      BOOKING_SERVICE_URL   = "http://booking-service:3003"
      PAYMENT_SERVICE_URL   = "http://payment-service:3004"
    }
    booking-service = {
      EVENT_SERVICE_URL = "http://event-service:3001"
      USER_SERVICE_URL  = "http://user-service:3002"
    }
    payment-service = {
      BOOKING_SERVICE_URL  = "http://booking-service:3003"
      STRIPE_SECRET_KEY    = ""
      STRIPE_WEBHOOK_SECRET = ""
      STRIPE_CURRENCY      = "usd"
      STRIPE_SUCCESS_URL   = "http://localhost:3004/api/payments/stripe/success"
      STRIPE_CANCEL_URL    = "http://localhost:3004/api/payments/stripe/cancel"
    }
  }
}
