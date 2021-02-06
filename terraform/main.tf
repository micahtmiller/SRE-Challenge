# resource "google_project_service" "run" {
#   service = "run.googleapis.com"
# }

resource "google_cloud_run_service" "app1" {
  name     = "app1"
  location = var.region

  template {
    spec {
      containers {
        # image = "gcr.io/cloudrun/hello"
        image = var.docker_image
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  # depends_on = [google_project_service.run]
}

resource "google_cloud_run_service_iam_member" "public" {
  service  = google_cloud_run_service.app1.name
  location = google_cloud_run_service.app1.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "url" {
  value = google_cloud_run_service.app1.status[0].url
}
