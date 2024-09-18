# Databricks Cluster Output
output "databricks_cluster_output" {
  value = { for key, value in databricks_cluster.cluster : key => {
    id    = value.id
    state = value.state
    }
  }
}
