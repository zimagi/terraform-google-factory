provider "google" {}

provider "google-beta" {}

module "zimagi_factory" {
  source = "./../.."

  org_id                  = var.org_id
  billing_account         = var.billing_account
  project_prefix          = var.project_prefix
  default_region          = var.default_region
  folder_id               = var.folder_id
  parent_folder           = var.parent_folder
  sa_enable_impersonation = var.sa_enable_impersonation
  cloud_source_repos      = var.cloud_source_repos
  users_org_admins        = []
  pool_name               = var.pool_name
  enable_force_destroy    = true
  master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  kubernetes_cluster_name = var.kubernetes_cluster_name
}