
provider "google" {}

provider "google-beta" {}

module "bootstrap_seed" {
  source  = "terraform-google-modules/bootstrap/google"
  version = "6.0.0"

  org_id         = var.org_id
  folder_id      = var.folder_id
  parent_folder  = var.parent_folder
  default_region = var.default_region
  random_suffix  = var.enable_random_suffix

  billing_account         = var.billing_account
  group_org_admins        = var.group_org_admins
  group_billing_admins    = var.group_billing_admins
  org_project_creators    = var.extra_org_project_creators
  sa_enable_impersonation = var.sa_enable_impersonation

  activate_apis = var.activate_seed_apis

  project_id     = var.seed_project_id
  project_prefix = var.seed_project_prefix

  state_bucket_name          = var.state_bucket_name
  encrypt_gcs_bucket_tfstate = var.encrypt_gcs_bucket_tfstate
  force_destroy              = var.enable_force_destroy


  tf_service_account_id   = var.tf_service_account_id
  tf_service_account_name = var.tf_service_account_name

  project_labels        = var.seed_project_labels
  storage_bucket_labels = var.storage_bucket_labels
}

module "bootstrap_build" {
  source  = "terraform-google-modules/bootstrap/google//modules/cloudbuild"
  version = "6.0.0"

  org_id                  = var.org_id
  folder_id               = var.folder_id
  sa_enable_impersonation = true
  billing_account         = var.billing_account
  group_org_admins        = var.group_org_admins
  random_suffix           = var.enable_random_suffix
  default_region          = var.default_region
  gcloud_version          = var.gcloud_version
  activate_apis           = var.activate_build_apis


  cloud_source_repos        = var.cloud_source_repos
  create_cloud_source_repos = var.create_cloud_source_repos
  gar_repo_name             = var.gar_repo_name

  cloudbuild_apply_filename = var.cloudbuild_apply_filename
  cloudbuild_plan_filename  = var.cloudbuild_plan_filename

  project_id     = var.build_project_id
  project_prefix = var.build_project_prefix

  terraform_sa_email     = module.bootstrap_seed.terraform_sa_email
  terraform_sa_name      = module.bootstrap_seed.terraform_sa_name
  terraform_state_bucket = module.bootstrap_seed.gcs_bucket_tfstate
}

module "project_zimagi" {
  source  = "terraform-google-modules/project-factory/google"
  version = "13.0.0"

  for_each = zimagi_projects

  name                        = "${var.project_prefix}-zimagi-${each.value.name}"
  random_project_id           = var.enable_random_suffix
  org_id                      = var.org_id
  billing_account             = var.billing_account
  auto_create_network         = false
  default_service_account     = "deprivilege"
  disable_services_on_destroy = false
  folder_id                   = var.folder_id

  activate_apis = each.value.activate_apis
}