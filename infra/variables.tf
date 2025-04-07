# We declare the variables here 

variable "project_id" {
  description = "ID du projet GCP"
  type        = string
}

variable "region" {
  description = "Région de déploiement"
  type        = string
}

variable "vpc_name" {
  type = string
}

variable "private_subnet_name" {
  type = string
}