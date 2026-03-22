variable "location" {
  default = "East US"
}

variable "resource_group_name" {}

variable "registry_name" {}

variable "image_tag" {
  default = "latest"
}

variable "services" {
  type = map(object({
    port = number
    db   = string
  }))
}

variable "postgres_user" {
  default = "postgres"
}

variable "postgres_password" {
  default   = "postgres"
  sensitive = true
}

variable "postgres_sslmode" {
  default     = "disable"
  description = "Set to require/verify-full for production deployments."
}

variable "jwt_secret" {
  default   = "demo-secret-change-in-production"
  sensitive = true
}

variable "jwt_refresh_secret" {
  default   = "demo-refresh-secret-change-in-production"
  sensitive = true
}

variable "google_client_id" {
  default   = "your-google-client-id"
  sensitive = true
}

variable "google_client_secret" {
  default   = "your-google-client-secret"
  sensitive = true
}

variable "google_redirect_uri" {
  default     = "http://localhost:3002/api/users/auth/google/callback"
  description = "Override for non-local deployments."
}

variable "frontend_success_url" {
  default     = "http://localhost:3002/google-auth-success.html"
  description = "Override for non-local deployments."
}

variable "frontend_dashboard_url" {
  default     = "http://localhost:3000/dashboard"
  description = "Override for non-local deployments."
}

variable "stripe_secret_key" {
  default   = ""
  sensitive = true
}

variable "stripe_webhook_secret" {
  default   = ""
  sensitive = true
}

variable "stripe_currency" {
  default = "usd"
}

variable "stripe_success_url" {
  default     = "http://localhost:3004/api/payments/stripe/success"
  description = "Override for non-local deployments."
}

variable "stripe_cancel_url" {
  default     = "http://localhost:3004/api/payments/stripe/cancel"
  description = "Override for non-local deployments."
}

variable "nginx_host" {
  default     = "localhost"
  description = "Override for non-local deployments."
}

variable "nginx_port" {
  type    = number
  default = 80
}
