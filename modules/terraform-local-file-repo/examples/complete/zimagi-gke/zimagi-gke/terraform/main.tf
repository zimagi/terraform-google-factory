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
  release_channel            = var.release_channel
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