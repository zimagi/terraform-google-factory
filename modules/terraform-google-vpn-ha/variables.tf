variable "gke_project_id" {
  description = "Production Project ID."
  type        = string
}

variable "gke_network_self_link" {
  description = "Production Network Self Link."
  type        = string
}

variable "gke_router_asn" {
  
}

variable "gke_0_peer_address" {
  
}

variable "gke_0_peer_asn" {
  
}

variable "gke_0_bgp_session_range" {
  
}

variable "gke_1_peer_address" {
  
}

variable "gke_1_peer_asn" {
  
}

variable "gke_1_bgp_session_range" {
  
}

variable "gke_cluster_control_plane_cidr" {
  
}

variable "cloudbuild_project_id" {
  description = "Management Project ID."
  type        = string
}

variable "cloudbuld_network_self_link" {
  description = "Management Network Self Link."
  type        = string
}

variable "cloudbuild_router_asn" {
  
}

variable "cloudbuild_0_peer_address" {
  
}

variable "cloudbuild_0_peer_asn" {
  
}

variable "cloudbuild_0_bgp_session_range" {
  
}

variable "cloudbuild_1_peer_address" {
  
}

variable "cloudbuild_1_peer_asn" {
  
}

variable "cloudbuild_1_bgp_session_range" {
  
}

variable "cloudbuild_vpc_cidr" {
  
}

variable "region" {
  description = "Region."
  type        = string
}