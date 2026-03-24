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
    KAFKA_BROKERS = "kafka:29092"
  }

  service_env = {
    event-service = {
      REDIS_HOST = "redis"
      REDIS_PORT = "6379"
    }
    user-service = {
      DATABASE_URL           = format("postgresql://%s:%s@postgres-user:5432/userdb?sslmode=%s", var.postgres_user, var.postgres_password, var.postgres_sslmode)
      KAFKA_BROKERS          = "kafka:29092"
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
      KAFKA_SEAT_LOCK_GROUP = "booking-seat-lock-processor"
      REDIS_ADDR           = "redis:6379"
      EVENT_SERVICE_URL    = "http://event-service.${local.internal_domain}"
      USER_SERVICE_URL     = "http://user-service.${local.internal_domain}"
    }
    payment-service = {
      KAFKA_RECONNECT_INTERVAL_MS = "15000"
      KAFKA_PAYMENTS_TOPIC        = "payments"
      REDIS_HOST                  = "redis"
      REDIS_PORT                  = "6379"
      BOOKING_SERVICE_URL         = "http://booking-service.${local.internal_domain}"
      STRIPE_SECRET_KEY           = var.stripe_secret_key
      STRIPE_WEBHOOK_SECRET       = var.stripe_webhook_secret
      STRIPE_CURRENCY             = var.stripe_currency
      STRIPE_SUCCESS_URL          = var.stripe_success_url
      STRIPE_CANCEL_URL           = var.stripe_cancel_url
    }
    notification-service = {
      KAFKA_BROKERS                = "kafka:29092"
      NOTIF_ROUTER_CLIENT_ID       = "notification-router"
      NOTIF_ROUTER_GROUP           = "notification-router"
      NOTIF_DOMAIN_TOPICS          = "bookings,payments,seat.lock.expired,waitlist,refunds"
      NOTIF_EMAIL_TOPIC            = "notif.email"
      NOTIF_SMS_TOPIC              = "notif.sms"
      NOTIF_PUSH_TOPIC             = "notif.push"
      NOTIF_WHATSAPP_TOPIC         = "notif.whatsapp"
      NOTIF_EMAIL_DLQ_TOPIC        = "notif.email.dlq"
      NOTIF_SMS_DLQ_TOPIC          = "notif.sms.dlq"
      NOTIF_PUSH_DLQ_TOPIC         = "notif.push.dlq"
      NOTIF_WHATSAPP_DLQ_TOPIC     = "notif.whatsapp.dlq"
      NOTIFICATION_WORKER_CHANNELS = "email,sms,push,whatsapp"
      SENDGRID_API_KEY             = var.sendgrid_api_key
      SENDGRID_FROM_EMAIL          = var.sendgrid_from_email
      TWILIO_ACCOUNT_SID           = var.twilio_account_sid
      TWILIO_AUTH_TOKEN            = var.twilio_auth_token
      TWILIO_SMS_FROM              = var.twilio_sms_from
      TWILIO_WHATSAPP_FROM         = var.twilio_whatsapp_from
    }
  }

  gateway_env = {
    NGINX_HOST          = var.nginx_host
    NGINX_PORT          = tostring(var.nginx_port)
    EVENT_SERVICE_URL   = "https://event-service.${local.internal_domain}" # http not https
    USER_SERVICE_URL    = "https://user-service.${local.internal_domain}"
    BOOKING_SERVICE_URL = "https://booking-service.${local.internal_domain}"
    PAYMENT_SERVICE_URL = "https://payment-service.${local.internal_domain}"
    NOTIFICATION_SERVICE_URL = "https://notification-service.${local.internal_domain}"
  }
}
