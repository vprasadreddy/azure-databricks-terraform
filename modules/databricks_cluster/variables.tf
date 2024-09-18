# Databricks Cluster Variables
variable "databricks_cluster_variables" {
  type = map(object({
    cluster_name            = string
    autotermination_minutes = number
    min_workers             = number
    max_workers             = number
    custom_tags             = map(string)
  }))
}
