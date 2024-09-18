data "databricks_node_type" "smallest" {
  provider   = databricks.workspace
  local_disk = true
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
  provider          = databricks.workspace
}

resource "databricks_cluster" "cluster" {
  for_each                = var.databricks_cluster_variables
  cluster_name            = each.value.cluster_name
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = data.databricks_node_type.smallest.id
  autotermination_minutes = each.value.autotermination_minutes
  autoscale {
    min_workers = each.value.min_workers
    max_workers = each.value.max_workers
  }
  custom_tags = each.value.custom_tags
  provider    = databricks.workspace
}
