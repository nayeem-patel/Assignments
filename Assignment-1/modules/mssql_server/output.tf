output "sql_server_name" {
  value = azurerm_mssql_server.mssql_server.name
}
output "sql_server_user_name" {
  value = azurerm_mssql_server.mssql_server.administrator_login
}
output "sql_server_user_password" {
  value = azurerm_mssql_server.mssql_server.administrator_login_password
}
output "sql_server_user_id" {
  value = azurerm_mssql_server.mssql_server.id
}