module "generate_zimagi_gke" {
  source = "./../.."

  cloudbuild_project_id = "zimagi-cloudbuild-835b"
  cloudbuild_region     = "europe-west2"
  projects = {
    develop = {
      default_location      = "europe-west2"
      env_project_id        = "zimagi-development-9c95"
      env_prefix            = "zimagi"
      env_environment       = "dev"
      env_name              = "develop"
      env_vpc_name          = "zimagi-gke"
      env_subnetwork        = "gke"
      env_subnet_ip         = "10.244.252.0/22"
      env_vpn_cidr_block    = "192.168.0.0/20"
      backend_config_bucket = "zimagi-tfstate-bf8b"
      cluster_name          = "zimagi-dev-develop"
    }
    main = {
      default_location      = "europe-west2"
      env_project_id        = "zimagi-production"
      env_prefix            = "eja"
      env_environment       = "prod"
      env_name              = "zimagi"
      env_vpc_name          = "zimagi-vpc"
      env_subnetwork        = "zimagi-vpc-subnet"
      env_subnet_ip         = "172.16.0.32/24"
      env_vpn_cidr_block    = "192.168.0.0/20"
      backend_config_bucket = "tfbucket"
      cluster_name          = "eja-prod-zimagi"
    }
  }
}