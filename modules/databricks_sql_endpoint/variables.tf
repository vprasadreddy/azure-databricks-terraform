# SQL Endpoint Variables
# variable "sql_warehouse_name" {
#   type = string
# }

# variable "sql_warehouse_cluster_size" {
#   type = string
# }

# variable "min_num_clusters" {
#   type = number
# }

# variable "max_num_clusters" {
#   type = number
# }

# variable "auto_stop_mins" {
#   type = number
# }

# variable "sql_warehouse_custom_tags" {
#   type = list(object({
#     key   = string
#     value = string
#   }))
# }

# variable "spot_instance_policy" {
#   type = string
# }

# variable "enable_photon" {
#   type = bool
# }

# variable "enable_serverless_compute" {
#   type = bool
# }

# variable "warehouse_type" {
#   type = string
# }

variable "sql_endpoint_variables" {
  type = map(object({
    sql_warehouse_name         = string
    sql_warehouse_cluster_size = string
    min_num_clusters           = number
    max_num_clusters           = number
    auto_stop_mins             = number
    tags = list(object({
      key   = string
      value = string
    }))
    spot_instance_policy      = string
    enable_photon             = bool
    enable_serverless_compute = bool
    warehouse_type            = string
    channel_name              = string
  }))
}
