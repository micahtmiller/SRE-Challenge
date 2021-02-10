variable "cluster_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
  default = []
}

variable "node_group_name" {
  type = string
}
