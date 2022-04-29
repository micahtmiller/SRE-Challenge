resource "google_cloud_run_service" "app1" {
  name     = var.app
  location = var.region

  template {
    spec {
      containers {
        # image = "gcr.io/cloudrun/hello"
        image = TF_VAR_docker_img
        resources {
          limits = { "memory" = "128Mi" }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

}

output "url" {
  value = google_cloud_run_service.app1.status[0].url
}