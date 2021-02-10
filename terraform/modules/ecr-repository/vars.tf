variable "ecr_repository_name" {
  type = string
}

variable "common_tags"{
  type = map(string)
  default = {}
}

variable "max_number_to_keep" {
  type = string
  default = "5"
}