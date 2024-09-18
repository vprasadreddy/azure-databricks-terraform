# Output when using Individual Variables
# output "databricks_sql_endpoint_id" {
#   value = databricks_sql_endpoint.sql_endpoint.id
# }

# Output when using Map(object({})) Variables
output "databricks_sql_endpoint_output" {
  value = { for key, value in databricks_sql_endpoint.sql_endpoint : key => {
    id = value.id
    }
  }
}
