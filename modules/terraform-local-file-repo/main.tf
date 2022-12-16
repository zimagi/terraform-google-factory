locals {
  zimagi_repo = format(
    "%s/%s",
    var.zimagi_repo_path,
    var.zimagi_repo_name
  )
  terraform_templates_path = "${path.module}/templates/terraform"
  helm_templates_path      = "${path.module}/templates/helm"
}

data "template_file" "terraform_main" {
  template = file("${local.terraform_templates_path}/main.tf.tpl")
}

resource "local_file" "terraform_main" {
  content  = data.template_file.terraform_main.rendered
  filename = "${local.zimagi_repo}/main.tf"
}

data "template_file" "terraform_env" {
  for_each = var.projects
  template = file("${local.terraform_templates_path}/env.tfvars.tpl")
  vars = {
    env_region              = "\"${each.value.default_location}\""
    env_project_id          = "\"${each.value.env_project_id}\""
    env_prefix              = "\"${each.value.env_prefix}\""
    env_environment         = "\"${each.value.env_environment}\""
    env_name                = "\"${each.value.env_name}\""
    env_vpc_name            = "\"${each.value.env_vpc_name}\""
    env_subnetwork          = "\"${each.value.env_subnetwork}\""
    env_subnet_ip           = "\"${each.value.env_subnet_ip}\""
    env_vpn_cidr_block      = "\"${each.value.env_vpn_cidr_block}\""
    enable_private_endpoint = "\"${each.value.enable_private_endpoint}\""
    enable_private_nodes    = "\"${each.value.enable_private_nodes}\""
  }
}

resource "local_file" "terraform_env" {
  for_each = var.projects
  content  = data.template_file.terraform_env[each.key].rendered
  filename = "${local.zimagi_repo}/env/${each.key}.tfvars"
}

data "template_file" "terraform_backend_config" {
  for_each = var.projects
  template = file("${local.terraform_templates_path}/backend_config.tf.tpl")
  vars = {
    backend_config_bucket = "\"${each.value.backend_config_bucket}\""
    backend_config_prefix = "\"/terraform-gcp/${each.key}.tfsate\""
  }
}

resource "local_file" "terraform_backend_config" {
  for_each = var.projects
  content  = data.template_file.terraform_backend_config[each.key].rendered
  filename = "${local.zimagi_repo}/backend_configs/${each.key}.tf"
}

data "template_file" "cloudbuild" {
  template = file("${path.module}/templates/cloudbuild.yaml.tpl")
  vars = {
    cloudbuild_project_id = var.cloudbuild_project_id
    cloudbuild_region     = var.cloudbuild_region
  }
}

resource "local_file" "cloudbuild" {
  content  = data.template_file.cloudbuild.rendered
  filename = "${local.zimagi_repo}/cloudbuild-tf-apply.yaml"
}

data "template_file" "argocd_values" {
  template = file("${local.helm_templates_path}/argocd_values.yaml.tpl")
  vars     = {}
}

resource "local_file" "argocd_values" {
  content  = data.template_file.argocd_values.rendered
  filename = "${local.zimagi_repo}/argocd_values.yaml"
}

data "template_file" "argocd_apps_values" {
  for_each = var.projects
  template = file("${local.helm_templates_path}/argocd_apps_values.yaml.tpl")
  vars = {
    nginx_host_name  = "\"${each.value.nginx_host_name}\""
    maintainer_email = "\"${each.value.maintainer_email}\""
    client_id        = "\"${each.value.client_id}\""
    client_secret    = "\"${each.value.client_secret}\""
  }
}

resource "local_file" "argocd_apps_values" {
  content  = data.template_file.argocd_apps_values.rendered
  filename = "${local.zimagi_repo}/argocd_apps_values.yaml"
}