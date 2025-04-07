terraform {
  required_version = ">= 1.4.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "iam" {
  source = "./modules/iam"
  project_id = var.project_id
}

module "network" {
  source     = "./modules/network"
  region = var.region
  project_id = var.project_id
}

module "gke" {
  source             = "./modules/gke"
  project_id         = var.project_id
  region             = var.region
  network_name       = var.vpc_name
  subnetwork_name    = var.private_subnet_name
  node_sa_email      = module.iam.gke_node_sa_email
}

