resource "azurerm_key_vault" "key_vault" {
  name                        = var.key_vault_name
  location                    = var.resource_location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"
  enabled_for_disk_encryption = true

}
resource "azurerm_key_vault_access_policy" "current-user" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = var.tenant_id
  object_id    = var.object_id
  secret_permissions = [
    "Set",
    "Get"
  ]

}