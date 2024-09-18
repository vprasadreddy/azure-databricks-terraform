output "databricks_permissions_output" {
  value = { for key, value in databricks_permissions.permissions : key => {
    id = value.id
    }
  }
}
