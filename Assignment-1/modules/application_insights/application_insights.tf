resource "azurerm_application_insights" "application_insights" {
  name                = var.appinsights_name
  location            = var.resource_location
  resource_group_name = var.resource_group_name
  workspace_id        = var.law_id
  application_type    = "web"
}
