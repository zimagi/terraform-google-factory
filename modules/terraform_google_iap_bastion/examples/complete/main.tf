provider "google" {}

module "iap_bastion" {
  source = "../.."
  project_id = var.project_id
  region = var.region
  prefix = var.prefix
  network = var.network
  subnet = var.subnet
  bastion_members = var.bastion_members
}