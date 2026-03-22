data "vercel_project" "frontend" {
  name = var.vercel_project_name
}

resource "vercel_project_environment_variable" "api_url" {
  project_id = data.vercel_project.frontend.id
  key        = "VITE_API_BASE_URL"
  value      = "https://${azurerm_container_app.gateway.ingress[0].fqdn}"
  target     = ["production", "preview", "development"]
  sensitive  = false

  depends_on = [azurerm_container_app.gateway]
}

resource "vercel_deployment" "frontend" {
  project_id = data.vercel_project.frontend.id
  ref        = var.vercel_branch
  production = true

  depends_on = [vercel_project_environment_variable.api_url]
}