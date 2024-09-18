resource "azurerm_databricks_workspace" "databricks_workspace" {
  for_each            = var.databricks_workspace_variables
  name                = each.value.databricks_workspace_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.resource_group_location
  sku                 = each.value.databricks_workspace_sku
  custom_parameters {
    storage_account_name     = each.value.storage_account_name
    storage_account_sku_name = each.value.storage_account_sku_name
  }
  tags = each.value.tags
}
