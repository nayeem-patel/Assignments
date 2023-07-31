terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {
}

resource "random_string" "suffix" {
  length  = 5
  spacial = false
  upper   = false
}

resource "random_password" "password" {
  length  = 14
  spacial = true
  lower   = true
  numeric = true
  upper   = true
}

module "resource_group" {
  source              = "../modules/resource_group"
  resource_group_name = var.resource_group_name
  resource_location   = var.resource_location
}
module "log_analytics_workspace" {
  source              = "../modules/log_analytics_workspace"
  law_name            = "law-Dev-${random_string.suffix.result}"
  resource_group_name = module.resource_group.resource_group_name
  resource_location   = module.resource_group.resource_group_location
}

module "application_insights" {
  source              = "../modules/application_insights"
  appinsights_name    = "appins-Dev-${random_string.suffix.result}"
  resource_group_name = module.resource_group.resource_group_name
  resource_location   = module.resource_group.resource_group_location
  law_id              = module.log_analytics_workspace.law_id
}

module "key vault" {
  source              = "../modules/key_vault"
  key_vault_name      = "vault-Dev-${random_string.suffix.result}"
  resource_group_name = module.resource_group.resource_group_name
  resource_location   = module.resource_group.resource_group_location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
}

module "app_service_plan_ui" {
  source                = "../modules/app_service_plan"
  app_service_plan_name = "aspui-Dev-${random_string.suffix.result}"
  resource_group_name   = module.resource_group.resource_group_name
  resource_location     = module.resource_group.resource_group_location
}

module "windows_web_app_ui" {
  source              = "../modules/windows_web_app"
  web_app_name        = "webui-Dev-${random_string.suffix.result}"
  app_service_plan_id = module.app_service_plan_ui.service_plan_id
  instrumentation_key = module.application_insights.instrumentation_key
  resource_group_name = module.resource_group.resource_group_name
  resource_location   = module.resource_group.resource_group_location
  vault_uri           = module.key_vault.keyvaultUrl
}

module "app_service_plan_bkd" {
  source                = "../modules/app_service_plan"
  app_service_plan_name = "aspbkd-Dev-${random_string.suffix.result}"
  resource_group_name   = module.resource_group.resource_group_name
  resource_location     = module.resource_group.resource_group_location
}

module "windows_web_app_bkd" {
  source              = "../modules/windows_web_app"
  web_app_name        = "webbkd-Dev-${random_string.suffix.result}"
  app_service_plan_id = module.app_service_plan_ui.service_plan_id
  instrumentation_key = module.application_insights.instrumentation_key
  resource_group_name = module.resource_group.resource_group_name
  resource_location   = module.resource_group.resource_group_location
  vault_uri           = module.key_vault.keyvaultUrl
}

module "mssql_server" {
  source              = "../modules/mssql_server"
  server_name         = "sql-Dev-${random_string.suffix.result}"
  resource_group_name = module.resource_group.resource_group_name
  resource_location   = module.resource_group.resource_group_location
  user_name           = random_string.suffix.result
  password            = random_password.password.result
}

module "mssql_database" {
  source          = "../modules/mssql_database"
  sqldb_name      = "sqldb-Dev-${random_string.suffix.result}"
  mssql_server_id = module.mssql_server.sql_server_id
}

resource "azurern_key_vault_secret" "InstrumentationKey_secret" {
  name         = "InstrumentationKey"
  value        = module.application_insights.instrumentation_key
  key_vault_id = module.key_vault.key_vault_id
}

resource "azurern_key_vault_secret" "sqldb_user" {
  name         = "sqlusername"
  value        = module.mssql_server.sql_server_user_name
  key_vault_id = module.key_vault.key_vault_id
}

resource "azurerm_key_vault_secret" "sqldb_password" {
  name         = "sqldbpassword"
  value        = module.mssql_server.sql_server_user_password
  key_vault_id = module.key_vault.key_vault_id
}

resource "azurerm_key_vault_access_policy" "web_msi" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.windows_web_app_bkd.principal_id
  secret_permissions = [
    "Set",
    "Get"
  ]
}
