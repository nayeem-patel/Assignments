resource "azurerm_mssql_database" "mssql_database" {
  name         = var.sqldb_name
  server_id    = var.mssql_server_id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 4
  read_scale   = false
  sku_name     = "S0"

}
