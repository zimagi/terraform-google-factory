provider "google" {}

module "iap_bastion" {
  source          = "../.."
  project_id      = var.project_id
  region          = var.region
  prefix          = var.prefix
  network         = var.network
  subnet_name     = var.subnet_name
  bastion_members = var.bastion_members
}