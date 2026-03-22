data "azurerm_container_registry" "acr" {
  name                = "tickbookregistry"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}