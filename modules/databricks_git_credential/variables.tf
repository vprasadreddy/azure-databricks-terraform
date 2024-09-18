# GIT Credentials Variables
variable "databricks_git_credential_variables" {
  type = map(object({
    git_username          = string
    git_provider          = string
    personal_access_token = string
  }))
}
