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
