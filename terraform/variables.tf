variable "location" {
  default = "East US"
}

variable "resource_group_name" {}

variable "registry_name" {}

variable "image_tag" {
  default = "latest"
}

variable "postgres_admin_user" {
  type        = string
  default     = "postgres"
  description = "PostgreSQL admin username for the container app databases."
}

variable "postgres_admin_password" {
  type        = string
  description = "PostgreSQL admin password for the container app databases (min 12 chars, upper/lowercase, number, special)."
  sensitive   = true

  validation {
    condition = alltrue([
      length(var.postgres_admin_password) >= 12,
      can(regex("[a-z]", var.postgres_admin_password)),
      can(regex("[A-Z]", var.postgres_admin_password)),
      can(regex("\\d", var.postgres_admin_password)),
      can(regex("[^A-Za-z0-9]", var.postgres_admin_password)),
    ])
    error_message = "postgres_admin_password must be at least 12 characters and include upper/lowercase, a number, and a special character."
  }
}

variable "services" {
  type = map(object({
    port = number
    db   = string
  }))
}
