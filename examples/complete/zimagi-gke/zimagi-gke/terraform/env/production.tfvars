region = "europe-west2"
project_id = "zimagi-production-f29d"
prefix = "zimagi"
environment = "production"
name = "zimagi"
vpc_name = "zimagi-gke"
subnetwork = "gke"
subnet_ip = "172.16.0.32/28"
master_authorized_networks = [
    {
        cidr_block = "192.168.0.0/20"
        display_name = "VPN"
    }
]
release_channel = "UNSPECIFIED"