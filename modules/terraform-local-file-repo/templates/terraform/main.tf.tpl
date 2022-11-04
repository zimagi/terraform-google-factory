provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  backend "gcs" {}
}

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
  release_channel = var.release_channel
  enable_private_nodes = var.enable_private_nodes
  enable_private_endpoint = var.enable_private_endpoint
  node_pools = {
    zimagi_nodes = [
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
}

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