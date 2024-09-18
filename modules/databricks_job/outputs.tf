output "databricks_job_output" {
  value = { for key, value in databricks_job.workflow_job : key => {
    id  = value.id
    url = value.url
    }
  }
}
