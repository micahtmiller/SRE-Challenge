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
  credentials = var.gc_creds
  project     = var.project
  region      = var.region
  zone        = var.zone
}
