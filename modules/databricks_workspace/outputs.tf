# output "databricks_host" {
#   value = "https://${azurerm_databricks_workspace.databricks_workspace.workspace_url}/"
# }

# output "databricks_workspace_resource_id" {
#   value = azurerm_databricks_workspace.databricks_workspace.id
# }

output "databricks_workspace_output" {
  value = { for key, value in azurerm_databricks_workspace.databricks_workspace : key => {
    workspace_url = value.workspace_url
    id            = value.id
    }
  }
}
