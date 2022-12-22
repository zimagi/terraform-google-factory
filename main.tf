locals {
  parent = var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${var.org_id}"
  # org_admins_org_iam_permissions = var.org_policy_admin_role == true ? [
  #   "roles/orgpolicy.policyAdmin", "roles/resourcemanager.organizationAdmin", "roles/billing.user"
  # ] : ["roles/resourcemanager.organizationAdmin", "roles/billing.user"]
}

locals {
  zimagi_projects = { for key, value in var.zimagi_projects : key => value if value.enable_private_endpoint == true }
  vpn = { for index in range(length(local.zimagi_projects)) : keys(local.zimagi_projects)[index] => {
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

locals {
  projects = { for k, v in var.zimagi_projects : k => {
    default_location        = var.default_region
    env_project_id          = module.zimagi_projects[k].project_id
    env_prefix              = var.project_prefix
    env_environment         = k
    env_name                = var.kubernetes_cluster_name
    env_vpc_name            = module.vpc[k].network_name
    env_subnetwork          = module.vpc[k].subnets_names[0]
    env_subnet_ip           = var.master_ipv4_cidr_block
    env_vpn_cidr_block      = module.worker_pool.vpc_cidr
    backend_config_bucket   = module.bootstrap_seed.gcs_bucket_tfstate
    cluster_name            = "${var.project_prefix}-${k}-${var.kubernetes_cluster_name}"
    enable_private_nodes    = v.enable_private_nodes
    enable_private_endpoint = v.enable_private_endpoint
    nginx_host_name         = "${google_compute_global_address.nginx_address[k].address}.nip.io"
    ip_address              = google_compute_global_address.nginx_address[k].address
    maintainer_email        = var.maintainer_email
    client_id               = var.client_id
    client_secret           = var.client_secret
  } }

}

module "generate_zimagi_gke_repo" {
  source = "./modules/terraform-local-file-repo"

  cloudbuild_project_id = module.bootstrap_build.cloudbuild_project_id
  cloudbuild_region     = var.default_region
  projects              = local.projects
}

resource "google_compute_global_address" "nginx_address" {
  for_each = var.zimagi_projects
  project  = module.zimagi_projects[each.key].project_id
  name     = "nginx-address"
}