resource "azurerm_windows_web_app" "web_app" {
name = var.web_app_name
location = var.resource_location
resource_group_name = var.resource_group_name
service_plan_id = var.app_service_plan_id
site_config {
    minimum_tls_version = "1.2"
}
identity {
    type = "SystemAssigned"
}
https_only = true
app_settings = {
"InstrumentationKey" =  var.instrumentation_key
"keyvaultUrl" = var.vault_uri
}
}