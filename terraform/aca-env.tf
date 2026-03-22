resource "azurerm_log_analytics_workspace" "log" {
  name                = "aca-logs"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
}

resource "azurerm_container_app_environment" "env" {
  name                       = "aca-env"
  location                   = var.location
  resource_group_name        = data.azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id
}