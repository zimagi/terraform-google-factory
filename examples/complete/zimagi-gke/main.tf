## Provider block ##

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "helm" {
  kubernetes {
    host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
    )
  }
}

## Data block ##

data "google_client_config" "provider" {}

data "google_container_cluster" "my_cluster" {
  name     = module.gke.cluster_name
  location = var.region
  project  = var.project_id
}

## State block ##

terraform {
  backend "gcs" {}
}

## Resources block ##

module "gke" {
  source = "git::https://github.com/zimagi/kubernetes-gke.git?ref=main"


  project_id                 = var.project_id
  region                     = var.region
  prefix                     = var.prefix
  environment                = var.environment
  name                       = var.name
  vpc_name                   = var.vpc_name
  subnetwork                 = var.subnetwork
  subnet_ip                  = var.subnet_ip
  master_authorized_networks = var.master_authorized_networks
  release_channel            = var.release_channel
  enable_private_nodes       = var.enable_private_nodes
  enable_private_endpoint    = var.enable_private_endpoint
  node_pools = [
    {
      name               = "default"
      machine_type       = "n2-standard-2"
      min_count          = 1
      max_count          = 10
      disk_size_gb       = 10
      disk_type          = "pd-ssd"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      initial_node_count = 1
    },
    {
      name               = "16x64"
      machine_type       = "n2-standard-16"
      min_count          = 0
      max_count          = 10
      disk_size_gb       = 10
      disk_type          = "pd-ssd"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      initial_node_count = 0
    },
    {
      name               = "12x85-gpu"
      machine_type       = "a2-highgpu-1g"
      min_count          = 0
      max_count          = 10
      disk_size_gb       = 10
      disk_type          = "pd-ssd"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      initial_node_count = 0
    }
  ]
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.13.5"
  namespace        = "argocd"
  create_namespace = true
  values = [
    "${file("argocd_values.yaml")}"
  ]
}

## Variables block ##

variable "project_id" {}

variable "region" {}

variable "prefix" {
  description = "prefix"
}

variable "environment" {
  description = "env"
}


variable "name" {
  description = "name"
}
variable "vpc_name" {
  default = ""
}

variable "subnetwork" {
  default = ""
}

variable "subnet_ip" {
  default = ""
}

variable "master_authorized_networks" {
  default = []
}

variable "release_channel" {

}

variable "enable_private_endpoint" {}

variable "enable_private_nodes" {}

## Outputs block ##