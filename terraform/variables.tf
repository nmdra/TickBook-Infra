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
  description = "PostgreSQL admin password for the container app databases."
  sensitive   = true

  validation {
    condition     = length(var.postgres_admin_password) >= 8
    error_message = "postgres_admin_password must be at least 8 characters."
  }
}

variable "services" {
  type = map(object({
    port = number
    db   = string
  }))
}
