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
        resources {
          limits = {"memory"="128Mi"}
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "2"
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

resource "google_monitoring_notification_channel" "basic" {
  display_name = "Team Alerts"
  type         = "email"
  labels = {
    email_address = var.notification_email
  }
}

resource "google_monitoring_alert_policy" "alert_policy" {
  display_name = "Denial of Money"
  combiner     = "OR"
  notification_channels = [google_monitoring_notification_channel.basic.name]
  conditions {
    display_name = "condition 1"
    condition_threshold {
      filter = "metric.type=\"run.googleapis.com/container/billable_instance_time\" resource.type=\"cloud_run_revision\" resource.label.\"service_name\"=\"app1\" resource.label.\"project_id\"=\"${var.project_id}\" resource.label.\"location\"=\"${var.region}\""
      duration   = "0s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period   = "60s"
        cross_series_reducer = "REDUCE_SUM"
        per_series_aligner = "ALIGN_RATE"
        group_by_fields = [ "resource.label.revision_name" ]
      }
      trigger {
        count = 1
      }
    }
  }
}

output "url" {
  value = google_cloud_run_service.app1.status[0].url
}
