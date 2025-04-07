# We use this account to create/modify GCP's infrastructure

resource "google_service_account" "terraform" {
  account_id   = "terraform-admin"
  display_name = "Terraform Admin SA"
}

resource "google_project_iam_member" "terraform_roles" {
  for_each = toset([
    "roles/container.admin",
    "roles/compute.admin",
    "roles/iam.serviceAccountUser",
  ])
  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.terraform.email}"
}

resource "google_service_account_key" "terraform_key" {
  service_account_id = google_service_account.terraform.name
  keepers = {
    version = 1
  }
}



# We use this account to allow nodes to give access to the Reader account

resource "google_service_account" "gke_nodes" {
  account_id   = "gke-node-pool"
  display_name = "GKE Node Pool SA"
}

resource "google_project_iam_member" "gke_node_roles" {
  for_each = toset([
    "roles/container.nodeServiceAccount",
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/secretmanager.secretAccessor"
  ])
  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}
