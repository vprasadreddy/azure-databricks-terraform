# Databricks Cluster Output
output "databricks_cluster_output" {
  value       = module.databricks_cluster.databricks_cluster_output
  description = "Databricks GIT Credentials Output Values."
}

# Databricks GIT Credentials Output
output "databricks_git_credential_output" {
  value       = module.databricks_git_credential.databricks_git_credential_output
  description = "Databricks GIT Credentials Output Values."
}
