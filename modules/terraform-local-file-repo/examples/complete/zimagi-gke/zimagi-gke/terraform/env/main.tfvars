region      = "europe-west2"
project_id  = "zimagi-production"
prefix      = "eja"
environment = "prod"
name        = "zimagi"
vpc_name    = "zimagi-vpc"
subnetwork  = "zimagi-vpc-subnet"
subnet_ip   = "172.16.0.32/24"
master_authorized_networks = [
  {
    cidr_block   = "192.168.0.0/20"
    display_name = "VPN"
  }
]
release_channel = "UNSPECIFIED"