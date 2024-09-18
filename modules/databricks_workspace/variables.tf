variable "databricks_workspace_variables" {
  type = map(object({
    resource_group_name       = string
    resource_group_location   = string
    databricks_workspace_name = string
    databricks_workspace_sku  = string
    storage_account_name      = string
    storage_account_sku_name  = string
    tags                      = map(string)
  }))
}
