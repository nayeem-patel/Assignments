resource "azurerm_mssql_server" "mssql_server" {
  name                         = var.server_name
  resource_group_name          = var.resource_group_name
  location                     = var.resource_location
  version                      = "12.0"
  administrator_login          = var.user_name
  administrator_login_password = var.password
}