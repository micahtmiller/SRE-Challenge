variable "project_id" {
  type        = string
  description = "GCP project id"
}

variable "region" {
  type    = string
  default = "us-west1"
}

variable "docker_image" {
  type        = string
  description = "The docker image to use for cloud run"
}

variable "notification_email" {
  type        = string
  description = "Email address for alerts"
}
