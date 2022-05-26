resource "google_cloud_run_service" "app1" {
  provider = google
  name     = var.app
  location = var.region

  template {
    spec {
      containers {
        image = var.docker_img
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

# Make Cloud Run service publicly accessible
resource "google_cloud_run_service_iam_member" "allUsers" {
  provider = google
  service  = google_cloud_run_service.app1.name
  location = google_cloud_run_service.app1.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "url" {
  value = google_cloud_run_service.app1.status[0].url
}