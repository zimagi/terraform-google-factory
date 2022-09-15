provider "google" {}

data "google_client_config" "provider" {}

data "google_container_cluster" "my_cluster" {
  name     = var.cluster_name
  location = var.default_location
  project  = var.project_id
}

terraform {
  backend "gcs" {}
}

provider "helm" {
  kubernetes {
    host  = "https://$${data.google_container_cluster.my_cluster.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
    )
  }
}

module "platform_charts" {
  source = "git::https://github.com/zimagi/terraform-helm-argocd.git?ref=master"

  argocd_values = [
    file("argocd_values.yaml")
  ]

  argocd_apps_values = [
    file("argocd_apps_values.yaml")
  ]
}

variable "cluster_name" {
  
}

variable "default_location" {
  
}

variable "project_id" {
  
}