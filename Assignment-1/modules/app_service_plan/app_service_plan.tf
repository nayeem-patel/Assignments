resource "azurerm_service_plan" "app_service_plan" {
  name                = var.app_service_plan_name
  location            = var.resource_location
  resource_group_name = var.resource_group_name
  sku_name            = "P1v2"
  os_type             = "Windows"
}