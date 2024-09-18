# Databricks Notebook Individual variables
# variable "notebook_subdirectory" {
#   description = "A name for the subdirectory to store the notebook."
#   type        = string
# }

# variable "notebook_filename" {
#   description = "The notebook's filename."
#   type        = string
# }

# variable "notebook_language" {
#   description = "The language of the notebook."
#   type        = string
# }

# variable "notebook_source" {
#   description = "The source of the notebook."
#   type        = string
# }

# Databricks Notebook Variables
variable "databricks_notebook_variables" {
  description = "Databricks Notebook Variables"
  type = map(object({
    source            = string # (Required)
    path_subdirectory = string # (Required) The absolute path of the notebook or directory, beginning with "/", e.g. "/Shared"
    filename          = string # (Required)
  }))
}
