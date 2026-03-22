output "env_domain" {
  description = "Default domain for the Azure Container Apps environment."
  value       = azurerm_container_app_environment.env.default_domain
}
