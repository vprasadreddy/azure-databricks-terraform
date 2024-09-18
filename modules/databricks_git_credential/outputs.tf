# Databricks GIT Credentials Output
output "databricks_git_credential_output" {
  value = { for key, value in databricks_git_credential.git_credential : key => {
    id = value.id
    }
  }
}
