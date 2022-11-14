module "worker_pool" {
  source = "./modules/terraform-google-private-pool"

  project_id          = data.google_project.cloudbuild.project_id
  network_name        = "${var.project_prefix}-${var.pool_name}"
  global_address_name = "${var.project_prefix}-${var.pool_name}"
  pool_name           = "${var.project_prefix}-${var.pool_name}"
  pool_location       = var.default_region
}