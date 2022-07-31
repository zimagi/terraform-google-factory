region = ${env_region}
project_id = ${env_project_id}
prefix = ${env_prefix}
environment = ${env_environment}
name = ${env_name}
vpc_name = ${env_vpc_name}
subnetwork = ${env_subnetwork}
subnet_ip = ${env_subnet_ip}
master_authorized_networks = [
    {
        cidr_block = ${env_vpn_cidr_block}
        display_name = "VPN"
    }
]