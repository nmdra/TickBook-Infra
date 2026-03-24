output "env_domain" {
  description = "Default domain for the Azure Container Apps environment."
  value       = azurerm_container_app_environment.env.default_domain
}

output "gateway_url" {
  description = "Public URL for the NGINX gateway."
  value       = "https://${azurerm_container_app.gateway.ingress[0].fqdn}"
}

output "vercel_deployment_url" {
  description = "Latest Vercel deployment URL"
  value       = vercel_deployment.frontend.url
}

output "kafbat_ui_url" {
  description = "Public URL for the Kafbat UI."
  value       = "https://${azurerm_container_app.kafbat_ui.ingress[0].fqdn}"
}
