resource "google_container_cluster" "primary" {
  name     = "gke-cluster"
  location = var.region

  network    = var.network_name
  subnetwork = var.subnetwork_name


# We can't create a cluster with no node pool defined so we delete it instantly.

  remove_default_node_pool = true
  initial_node_count       = 1

  node_config {
    service_account = var.node_sa_email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    tags = ["gke-node"]
  }

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  enable_shielded_nodes = true
  deletion_protection = false
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 2

  node_config {
    machine_type = "e2-medium"
    disk_size_gb  = 50
    disk_type     = "pd-balanced"
    service_account = var.node_sa_email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    tags = ["gke-node"]
  }
}
