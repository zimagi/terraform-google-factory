locals {
  bastion_name = format("%s-bastion", var.prefix)
  bastion_zone = format("%s-a", var.region)
}

data "template_file" "startup_script" {
  template = <<-EOF
  sudo apt-get update -y
  sudo apt-get install -y \
    tinyproxy\
    kubectl\
    google-cloud-sdk-gke-gcloud-auth-plugin
  EOF
}

data "google_compute_subnetwork" "this" {
  project = var.project_id
  name    = var.subnet_name
  region  = var.region
}

resource "google_project_service" "this" {
  project = var.project_id
  service = "iap.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
  disable_on_destroy         = true
}

module "bastion" {
  source  = "terraform-google-modules/bastion-host/google"
  version = "~> 5.0"

  network        = var.network
  subnet         = data.google_compute_subnetwork.this.self_link
  project        = var.project_id
  host_project   = var.project_id
  name           = local.bastion_name
  zone           = local.bastion_zone
  image_project  = "debian-cloud"
  machine_type   = "e2-medium"
  startup_script = data.template_file.startup_script.rendered
  members        = var.bastion_members
  shielded_vm    = "false"
  service_account_roles = [
    "roles/container.developer"
  ]

  depends_on = [
    google_project_service.this
  ]
}