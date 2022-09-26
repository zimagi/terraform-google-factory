locals {
  parent = var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${var.org_id}"
  # org_admins_org_iam_permissions = var.org_policy_admin_role == true ? [
  #   "roles/orgpolicy.policyAdmin", "roles/resourcemanager.organizationAdmin", "roles/billing.user"
  # ] : ["roles/resourcemanager.organizationAdmin", "roles/billing.user"]
}

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

locals {

}

module "vpc" {
  depends_on = [
    module.zimagi_projects
  ]
  for_each = var.zimagi_projects
  source   = "terraform-google-modules/network/google"
  version  = "5.0.0"

  project_id   = module.zimagi_projects[each.key].project_id
  network_name = "${var.project_prefix}-gke"

  auto_create_subnetworks = false
  shared_vpc_host         = false
  # firewall_rules          = var.firewall_rules
  # routes                  = var.routes

  subnets = [
    {
      subnet_name   = "gke"
      subnet_ip     = "10.244.252.0/22"
      subnet_region = var.default_region
    },
  ]

  secondary_ranges = {
    gke = [
      {
        range_name    = "pods"
        ip_cidr_range = "10.4.0.0/14"
      },
      {
        range_name    = "services"
        ip_cidr_range = "10.0.32.0/20"
      },
    ]
  }
}

module "worker_pool" {
  source = "./modules/terraform-google-private-pool"

  project_id          = data.google_project.cloudbuild.project_id
  network_name        = "${var.project_prefix}-${var.pool_name}"
  global_address_name = "${var.project_prefix}-${var.pool_name}"
  pool_name           = "${var.project_prefix}-${var.pool_name}"
  pool_location       = var.default_region
}

locals {
  vpn = { for index in range(length(var.zimagi_projects)) : keys(var.zimagi_projects)[index] => {
    asn      = 65000 + (2 * index) + 2
    peer_asn = 65000 + (2 * index) + 1
    remote-0 = {
      address        = "169.254.${2 * index}.2"
      remote_address = "169.254.${2 * index}.1"
    }
    remote-1 = {
      address        = "169.254.${2 * index + 1}.2"
      remote_address = "169.254.${2 * index + 1}.1"
    }
  } }
}

module "vpn" {
  source                         = "./modules/terraform-google-vpn-ha"
  for_each                       = var.zimagi_projects
  region                         = var.default_region
  gke_project_id                 = module.zimagi_projects[each.key].project_id
  gke_network_self_link          = module.vpc[each.key].network_self_link
  gke_router_asn                 = local.vpn[each.key].asn
  gke_0_peer_address             = local.vpn[each.key]["remote-0"].remote_address
  gke_0_peer_asn                 = local.vpn[each.key].peer_asn
  gke_0_bgp_session_range        = "${local.vpn[each.key]["remote-0"].address}/${var.bgp_session_range}"
  gke_1_peer_address             = local.vpn[each.key]["remote-1"].remote_address
  gke_1_peer_asn                 = local.vpn[each.key].peer_asn
  gke_1_bgp_session_range        = "${local.vpn[each.key]["remote-1"].address}/${var.bgp_session_range}"
  gke_cluster_control_plane_cidr = var.master_ipv4_cidr_block


  cloudbuild_project_id          = data.google_project.cloudbuild.project_id
  cloudbuld_network_self_link    = module.worker_pool.network_self_link
  cloudbuild_router_asn          = local.vpn[each.key].peer_asn
  cloudbuild_0_peer_address      = local.vpn[each.key]["remote-0"].address
  cloudbuild_0_peer_asn          = local.vpn[each.key].asn
  cloudbuild_0_bgp_session_range = "${local.vpn[each.key]["remote-0"].remote_address}/${var.bgp_session_range}"
  cloudbuild_1_peer_address      = local.vpn[each.key]["remote-1"].address
  cloudbuild_1_peer_asn          = local.vpn[each.key].asn
  cloudbuild_1_bgp_session_range = "${local.vpn[each.key]["remote-1"].remote_address}/${var.bgp_session_range}"
  cloudbuild_vpc_cidr            = module.worker_pool.vpc_cidr
}

resource "google_compute_router" "router" {
  for_each = var.zimagi_projects
  project  = module.zimagi_projects[each.key].project_id
  name     = "nat-router"
  network  = module.vpc[each.key].network_name
  region   = var.default_region
}

module "cloud-nat" {
  depends_on = [
    google_compute_router.router
  ]
  for_each                           = var.zimagi_projects
  source                             = "terraform-google-modules/cloud-nat/google"
  version                            = "2.2.1"
  project_id                         = module.zimagi_projects[each.key].project_id
  region                             = var.default_region
  router                             = google_compute_router.router[each.key].name
  name                               = "nat-config"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

locals {
  projects = { for k, v in var.zimagi_projects : k => {
    default_location      = var.default_region
    env_project_id        = module.zimagi_projects[k].project_id
    env_prefix            = var.project_prefix
    env_environment       = k
    env_name              = var.kubernetes_cluster_name
    env_vpc_name          = module.vpc[k].network_name
    env_subnetwork        = module.vpc[k].subnets_names[0]
    env_subnet_ip         = var.master_ipv4_cidr_block
    env_vpn_cidr_block    = module.worker_pool.vpc_cidr
    backend_config_bucket = module.bootstrap_seed.gcs_bucket_tfstate
    cluster_name          = "${var.project_prefix}-${k}-${var.kubernetes_cluster_name}"
  } }
}

module "generate_zimagi_gke_repo" {
  source = "./modules/terraform-local-file-repo"

  cloudbuild_project_id = module.bootstrap_build.cloudbuild_project_id
  cloudbuild_region     = var.default_region
  projects              = local.projects
}