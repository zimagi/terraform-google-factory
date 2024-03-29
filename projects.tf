module "bootstrap_seed" {
  source = "./modules/terraform-google-bootstrap-project"

  org_id        = var.org_id
  folder_id     = var.folder_id
  parent_folder = var.parent_folder == "" ? "" : local.parent

  default_region = var.default_region
  random_suffix  = var.enable_random_suffix

  billing_account      = var.billing_account
  group_org_admins     = var.group_org_admins
  group_billing_admins = var.group_billing_admins
  users_org_admins     = var.users_org_admins
  org_project_creators = var.extra_org_project_creators

  sa_enable_impersonation                    = var.sa_enable_impersonation
  enable_cross_project_service_account_usage = var.enable_cross_project_service_account_usage

  activate_apis = [
    "serviceusage.googleapis.com",
    "servicenetworking.googleapis.com",
    "cloudkms.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "logging.googleapis.com",
    "bigquery.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudbuild.googleapis.com",
    "iam.googleapis.com",
    "admin.googleapis.com",
    "appengine.googleapis.com",
    "storage-api.googleapis.com",
    "monitoring.googleapis.com",
    "pubsub.googleapis.com",
    "securitycenter.googleapis.com",
    "accesscontextmanager.googleapis.com",
    "iamcredentials.googleapis.com",
    "billingbudgets.googleapis.com"
  ]

  sa_org_iam_permissions = [
    "roles/accesscontextmanager.policyAdmin",
    "roles/compute.networkAdmin",
    "roles/compute.xpnAdmin",
    "roles/iam.securityAdmin",
    "roles/logging.configWriter",
    "roles/resourcemanager.projectCreator",
    "roles/resourcemanager.folderAdmin",
    "roles/source.reader",
    "roles/compute.viewer",
    "roles/container.clusterAdmin",
    "roles/container.developer",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountUser",
    "roles/resourcemanager.projectIamAdmin",
    "roles/container.admin",
    "roles/container.hostServiceAgentUser",
    "roles/securitycenter.notificationConfigEditor",
  ]

  project_id     = var.seed_project_id
  project_prefix = var.project_prefix

  state_bucket_name          = var.state_bucket_name
  encrypt_gcs_bucket_tfstate = var.encrypt_gcs_bucket_tfstate
  force_destroy              = var.enable_force_destroy

  tf_service_account_id   = var.tf_service_account_id
  tf_service_account_name = var.tf_service_account_name

  project_labels        = var.seed_project_labels
  storage_bucket_labels = var.storage_bucket_labels
}

module "bootstrap_build" {
  source = "./modules/terraform-google-bootstrap-cloudbuild"

  org_id          = var.org_id
  folder_id       = var.folder_id
  billing_account = var.billing_account
  # group_org_admins  = var.group_org_admins

  sa_enable_impersonation                    = var.sa_enable_impersonation
  enable_cross_project_service_account_usage = var.enable_cross_project_service_account_usage

  random_suffix  = var.enable_random_suffix
  default_region = var.default_region
  gcloud_version = var.gcloud_version

  activate_apis = [
    "serviceusage.googleapis.com",
    "servicenetworking.googleapis.com",
    "compute.googleapis.com",
    "logging.googleapis.com",
    "bigquery.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "admin.googleapis.com",
    "appengine.googleapis.com",
    "storage-api.googleapis.com",
    "iamcredentials.googleapis.com",
    "billingbudgets.googleapis.com"
  ]

  cloud_source_repos        = var.cloud_source_repos
  create_cloud_source_repos = var.create_cloud_source_repos
  gar_repo_name             = var.gar_repo_name

  cloudbuild_apply_filename = var.cloudbuild_apply_filename
  cloudbuild_plan_filename  = var.cloudbuild_plan_filename

  project_id     = var.build_project_id
  project_prefix = var.project_prefix

  terraform_sa_email     = module.bootstrap_seed.terraform_sa_email
  terraform_sa_name      = module.bootstrap_seed.terraform_sa_name
  terraform_state_bucket = module.bootstrap_seed.gcs_bucket_tfstate

}

data "google_project" "cloudbuild" {
  project_id = module.bootstrap_build.cloudbuild_project_id

  depends_on = [module.bootstrap_build.csr_repos]
}

resource "google_folder_iam_member" "org_cb_sa_iam_viewer" {
  folder = var.folder_id
  role   = "roles/iam.securityReviewer"
  member = "serviceAccount:${data.google_project.cloudbuild.number}@cloudbuild.gserviceaccount.com"
}

resource "google_folder_iam_member" "folder_cb_sa_browser" {
  folder = var.folder_id
  role   = "roles/browser"
  member = "serviceAccount:${data.google_project.cloudbuild.number}@cloudbuild.gserviceaccount.com"
}

# resource "google_folders_iam_member" "org_tf_compute_security_policy_admin" {
#   count  = var.parent_folder == "" ? 1 : 0
#   org_id = var.org_id
#   role   = "roles/compute.orgSecurityPolicyAdmin"
#   member = "serviceAccount:${module.bootstrap_seed.terraform_sa_email}"
# }

# resource "google_folder_iam_member" "folder_tf_compute_security_policy_admin" {
#   count  = var.parent_folder != "" ? 1 : 0
#   folder = var.parent_folder
#   role   = "roles/compute.orgSecurityPolicyAdmin"
#   member = "serviceAccount:${module.bootstrap_seed.terraform_sa_email}"
# }

# resource "hashicorp/terraform:light_iam_member" "org_tf_compute_security_resource_admin" {
#   count  = var.parent_folder == "" ? 1 : 0
#   org_id = var.org_id
#   role   = "roles/compute.orgSecurityResourceAdmin"
#   member = "serviceAccount:${module.bootstrap_seed.terraform_sa_email}"
# }

# resource "google_folder_iam_member" "folder_tf_compute_security_resource_admin" {
#   count  = var.parent_folder != "" ? 1 : 0
#   folder = var.parent_folder
#   role   = "roles/compute.orgSecurityResourceAdmin"
#   member = "serviceAccount:${module.bootstrap_seed.terraform_sa_email}"
# }

module "zimagi_projects" {
  for_each                    = var.zimagi_projects
  source                      = "terraform-google-modules/project-factory/google"
  version                     = "13.0.0"
  name                        = "${var.project_prefix}-${each.value.name}"
  random_project_id           = each.value.enable_random_suffix
  disable_services_on_destroy = false
  folder_id                   = var.folder_id
  org_id                      = var.org_id
  billing_account             = var.billing_account
  activate_apis               = each.value.activate_apis
  labels                      = each.value.project_labels
}