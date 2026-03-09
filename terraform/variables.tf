variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "project_name" {
  description = "Project name used as prefix for all resources"
  type        = string
  default     = "tickbook"
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Environment name (e.g. demo, dev, prod)"
  type        = string
  default     = "demo"
}

# AKS
variable "aks_node_count" {
  description = "Number of AKS worker nodes"
  type        = number
  default     = 1
}

variable "aks_vm_size" {
  description = "VM size for AKS nodes (cost-optimized for demo)"
  type        = string
  default     = "Standard_B2s"
}

variable "kubernetes_version" {
  description = "Kubernetes version for AKS"
  type        = string
  default     = "1.30"
}

# Network
variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "aks_subnet_prefix" {
  description = "Address prefix for the AKS subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "db_subnet_prefix" {
  description = "Address prefix for the database subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

# PostgreSQL
variable "postgres_sku" {
  description = "SKU for PostgreSQL Flexible Server (cost-optimized for demo)"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "postgres_storage_mb" {
  description = "Storage in MB for PostgreSQL"
  type        = number
  default     = 32768
}

variable "postgres_admin_login" {
  description = "PostgreSQL administrator login"
  type        = string
  default     = "pgadmin"
}

variable "postgres_admin_password" {
  description = "PostgreSQL administrator password"
  type        = string
  sensitive   = true
}

variable "postgres_version" {
  description = "PostgreSQL major version"
  type        = string
  default     = "17"
}

# Event Hubs (Kafka)
variable "eventhub_sku" {
  description = "SKU for Event Hubs namespace"
  type        = string
  default     = "Basic"
}

variable "eventhub_capacity" {
  description = "Throughput units for Event Hubs"
  type        = number
  default     = 1
}
