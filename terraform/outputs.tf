output "env_domain" {
  description = "Default domain for the Azure Container Apps environment."
  value       = azurerm_container_app_environment.env.default_domain
}

output "gateway_url" {
  description = "Public URL for the NGINX gateway."
  value       = "https://${azurerm_container_app.gateway.latest_revision_fqdn}"
}
