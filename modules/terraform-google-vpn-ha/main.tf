module "vpn-ha-to-gke" {
  source           = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version          = "2.3.0"
  project_id       = var.cloudbuild_project_id
  region           = var.region
  network          = var.cloudbuld_network_self_link
  name             = "cloudbuild-to-${var.gke_project_id}"
  peer_gcp_gateway = module.vpn-ha-to-cloudbuild.self_link
  router_asn       = var.cloudbuild_router_asn
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = var.cloudbuild_0_peer_address
        asn     = var.cloudbuild_0_peer_asn
      }
      bgp_peer_options = {
        advertise_groups = []
        advertise_ip_ranges = {
          "${var.cloudbuild_vpc_cidr}" = "cidr"
        }
        advertise_mode = "CUSTOM"
        route_priority = 100
      }
      bgp_session_range               = var.cloudbuild_0_bgp_session_range
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = null
      shared_secret                   = ""
    }
    remote-1 = {
      bgp_peer = {
        address = var.cloudbuild_1_peer_address
        asn     = var.cloudbuild_1_peer_asn
      }
      bgp_peer_options = {
        advertise_groups = []
        advertise_ip_ranges = {
          "${var.cloudbuild_vpc_cidr}" = "cidr"
        }
        advertise_mode = "CUSTOM"
        route_priority = 100
      }
      bgp_session_range               = var.cloudbuild_1_bgp_session_range
      ike_version                     = 2
      vpn_gateway_interface           = 1
      peer_external_gateway_interface = null
      shared_secret                   = ""
    }
  }
}

module "vpn-ha-to-cloudbuild" {
  source           = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version          = "2.3.0"
  project_id       = var.gke_project_id
  region           = var.region
  network          = var.gke_network_self_link
  name             = "${var.gke_project_id}-to-cloudbuild"
  router_asn       = var.gke_router_asn
  peer_gcp_gateway = module.vpn-ha-to-gke.self_link
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = var.gke_0_peer_address
        asn     = var.gke_0_peer_asn
      }
      bgp_peer_options = {
        advertise_groups = []
        advertise_ip_ranges = {
          "${var.gke_cluster_control_plane_cidr}" = "cidr"
        }
        advertise_mode = "CUSTOM"
        route_priority = 100
      }
      bgp_session_range               = var.gke_0_bgp_session_range
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = null
      shared_secret                   = module.vpn-ha-to-gke.random_secret
    }
    remote-1 = {
      bgp_peer = {
        address = var.gke_1_peer_address
        asn     = var.gke_1_peer_asn
      }
      bgp_peer_options = {
        advertise_groups = []
        advertise_ip_ranges = {
          "${var.gke_cluster_control_plane_cidr}" = "cidr"
        }
        advertise_mode = "CUSTOM"
        route_priority = 100
      }
      bgp_session_range               = var.gke_1_bgp_session_range
      ike_version                     = 2
      vpn_gateway_interface           = 1
      peer_external_gateway_interface = null
      shared_secret                   = module.vpn-ha-to-gke.random_secret
    }
  }
}