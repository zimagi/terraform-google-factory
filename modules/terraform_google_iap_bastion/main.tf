locals {
  bastion_name = format("%s-bastion", var.prefix)
  bastion_zone = format("%s-a", var.region)
}

data "template_file" "startup_script" {
  template = <<-EOF
  sudo apt-get update -y
  sudo apt-get install -y tinyproxy
  EOF
}

module "bastion" {
  source  = "terraform-google-modules/bastion-host/google"
  version = "~> 5.0"

  network        = var.network
  subnet         = var.subnet
  project        = var.project_id
  host_project   = var.project_id
  name           = local.bastion_name
  zone           = local.bastion_zone
  image_project  = "debian-cloud"
  machine_type   = "e2-medium"
  startup_script = data.template_file.startup_script.rendered
  members        = var.bastion_members
  shielded_vm    = "false"
}