variable "resource_group_variables" {
  type = map(object({
    name     = string
    location = string
    tags     = map(string)
  }))
}
