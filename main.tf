module "resource_group" {
  source                   = "./modules/resource_group"
  resource_group_variables = var.resource_group_variables
}

module "databricks_workspace" {
  depends_on                     = [module.resource_group]
  source                         = "./modules/databricks_workspace"
  databricks_workspace_variables = var.databricks_workspace_variables
}

module "databricks_git_credential" {
  depends_on                          = [module.databricks_workspace]
  source                              = "./modules/databricks_git_credential"
  databricks_git_credential_variables = var.databricks_git_credential_variables
  providers = {
    databricks.workspace = databricks
  }
}

module "databricks_service_principal" {
  depends_on                  = [module.databricks_workspace]
  source                      = "./modules/databricks_service_principal"
  service_principal_variables = var.service_principal_variables
  providers = {
    databricks.workspace = databricks
  }
}

module "databricks_cluster" {
  depends_on                   = [module.databricks_workspace]
  source                       = "./modules/databricks_cluster"
  databricks_cluster_variables = var.databricks_cluster_variables
  providers = {
    databricks.workspace = databricks
  }
}

# module "sql_endpoint" {
#   depends_on             = [module.databricks_workspace]
#   source                 = "./modules/databricks_sql_endpoint"
#   sql_endpoint_variables = var.sql_endpoint_variables
#   providers = {
#     databricks.workspace = databricks
#   }
# }

# module "databricks_notebook" {
#   depends_on                    = [module.databricks_cluster]
#   source                        = "./modules/databricks_notebook"
#   databricks_notebook_variables = var.databricks_notebook_variables
#   providers = {
#     databricks.workspace = databricks
#   }
# }

module "databricks_job" {
  depends_on               = [module.databricks_cluster]
  source                   = "./modules/databricks_job"
  databricks_job_variables = var.databricks_job_variables
  providers = {
    databricks.workspace = databricks
  }
}

module "databricks_permissions" {
  depends_on                       = [module.databricks_cluster, module.databricks_job, module.databricks_service_principal]
  source                           = "./modules/databricks_permissions"
  databricks_permissions_variables = var.databricks_permissions_variables
  providers = {
    databricks.workspace = databricks
  }
}


