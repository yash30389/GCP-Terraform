provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_project_service" "run" {
  project = var.project_id
  service = "run.googleapis.com"
}

resource "google_project_service" "cloudbuild" {
  project = var.project_id
  service = "cloudbuild.googleapis.com"
}

resource "google_project_service" "artifactregistry" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"
}

resource "google_artifact_registry_repository" "repo" {
  provider = google-beta
  location = var.region
  repository_id = "my-repo"
  description = "Docker repository"
  format = "DOCKER"
}

resource "google_cloud_run_service" "service" {
  name     = "hello-world-service"
  location = var.region

  template {
    spec {
      containers {
        image = "us-central1-docker.pkg.dev/${var.project_id}/my-repo/hello-world:latest"
        ports {
          container_port = 8080
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true
}

resource "google_cloud_run_service_iam_member" "invoker" {
  service = google_cloud_run_service.service.name
  location = google_cloud_run_service.service.location
  role = "roles/run.invoker"
  member = "allUsers"
}
