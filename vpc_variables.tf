variable "master_ipv4_cidr_block" {
  default = "172.16.0.0/28"
}

variable "vpn_shared_secret" {
  default = "secret"
}

variable "bgp_session_range" {
  default = "30"
}

variable "users_org_admins" {
  default = []
}