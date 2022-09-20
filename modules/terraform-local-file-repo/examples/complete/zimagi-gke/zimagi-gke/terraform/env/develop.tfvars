region      = "europe-west2"
project_id  = "zimagi-development-9c95"
prefix      = "zimagi"
environment = "dev"
name        = "develop"
vpc_name    = "zimagi-gke"
subnetwork  = "gke"
subnet_ip   = "10.244.252.0/22"
master_authorized_networks = [
  {
    cidr_block   = "192.168.0.0/20"
    display_name = "VPN"
  }
]
release_channel = "UNSPECIFIED"