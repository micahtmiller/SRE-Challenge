variable "project_id" {}

variable "gcp_creds" {}

variable "region" {
  type        = string
  description = "GCP region"
  default     = "us-central1"
}

variable "zone" {
  default = "us-central1-a"
}

variable "docker_img" {}

variable "app" {
  default = "dyn-enable-app"
}
