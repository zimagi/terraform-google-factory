data "google_compute_network" "default" {
  project = var.project_id
  name    = var.network_name
}

resource "google_compute_address" "nginx" {
  for_each = var.zimagi_projects
  project  = module.zimagi_projects[each.key].name
  region   = var.region
  name     = "ipv4-address"
}

resource "google_compute_subnetwork" "default" {
  project       = var.project_id
  name          = "test-subnetwork"
  ip_cidr_range = "10.2.0.0/24"
  region        = var.region
  network       = data.google_compute_network.default.id
}

module "vm" {
  source  = "terraform-google-modules/vm/google"
  version = "7.8.0"
}

module "instance_template" {
  source          = "terraform-google-modules/vm/google//modules/instance_template"
  version         = "7.8.0"
  region          = var.region
  project_id      = var.project_id
  subnetwork      = google_compute_subnetwork.default.self_link
  service_account = var.service_account
}

module "compute_instance" {
  source              = "terraform-google-modules/vm/google//modules/compute_instance"
  region              = var.region
  zone                = var.zone
  subnetwork          = google_compute_subnetwork.default.self_link
  num_instances       = var.num_instances
  hostname            = "instance-simple"
  instance_template   = module.instance_template.self_link
  deletion_protection = false

  access_config = [{
    nat_ip       = google_compute_address.default.address
    network_tier = var.network_tier
  }, ]
}

variable "project_id" {
  description = "The GCP project to use for integration tests"
  type        = string
}

variable "region" {
  description = "The GCP region to create and test resources in"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone to create resources in"
  type        = string
  default     = null
}

# variable "subnetwork" {
#   description = "The subnetwork selflink to host the compute instances in"
# }

variable "num_instances" {
  description = "Number of instances to create"
}

# variable "nat_ip" {
#   description = "Public ip address"
#   default     = null
# }

variable "network_tier" {
  description = "Network network_tier"
  default     = "PREMIUM"
}

variable "deletion_protection" {
  type        = bool
  description = "Enable deletion protection on this instance. Note: you must disable deletion protection before removing the resource, or the instance cannot be deleted and the Terraform run will not complete successfully."
  default     = false
}

variable "service_account" {
  default = null
  type = object({
    email  = string,
    scopes = set(string)
  })
  description = "Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#service_account."
}

variable "network_name" {

}

output "instances_self_links" {
  description = "List of self-links for compute instances"
  value       = module.compute_instance.instances_self_links
}

output "available_zones" {
  description = "List of available zones in region"
  value       = module.compute_instance.available_zones
}
