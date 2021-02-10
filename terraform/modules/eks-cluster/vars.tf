variable "eks_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
  default = []
}