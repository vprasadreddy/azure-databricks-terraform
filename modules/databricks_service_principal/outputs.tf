# Output when using Individual Variables
# output "databricks_service_principal_id" {
#   value = databricks_service_principal.service_principal.id
# }


# Output when using Map(object({})) Variables
output "databricks_service_principal_output" {
  value = { for key, value in databricks_service_principal.service_principal : key => {
    id = value.id
    }
  }
}
