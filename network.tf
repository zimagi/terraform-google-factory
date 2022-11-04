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

module "vpn" {
  source                         = "./modules/terraform-google-vpn-ha"
  for_each                       = local.vpn
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