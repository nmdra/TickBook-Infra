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