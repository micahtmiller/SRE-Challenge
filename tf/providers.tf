terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 2.13.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

provider "google" {
  # credentials = file("deft-weaver-346622-51fa8dd0c029.json")
  credentials = file(var.gcp_creds)

  project = var.project_id
  region  = var.region
  zone    = var.zone
}
