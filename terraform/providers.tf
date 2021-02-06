provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  backend "gcs" {
    bucket = "sre-chal-tf-state"
    prefix = "terraform/state"
  }
}
