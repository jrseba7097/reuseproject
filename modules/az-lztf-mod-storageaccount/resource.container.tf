resource "azurerm_storage_container" "main" {
  count = length(var.containers)

  name                 = var.containers[count.index]
  storage_account_name = azurerm_storage_account.main.name
}
