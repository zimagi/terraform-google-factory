locals {
  zimagi_repo = format(
    "%s/%s",
    var.zimagi_repo_path,
    var.zimagi_repo_name
  )
}

data "template_file" "terraform_main" {
  template = file("${path.module}/templates/terraform/main.tf.tpl")
}

resource "local_file" "terraform_main" {
  content  = data.template_file.terraform_main.rendered
  filename = "${local.zimagi_repo}/zimagi-gke/terraform/main.tf"
}

data "template_file" "terraform_env" {
  for_each = var.projects
  template = file("${path.module}/templates/terraform/env.tfvars.tpl")
  vars = {
    env_region         = "\"${each.value.default_location}\""
    env_project_id     = "\"${each.value.env_project_id}\""
    env_prefix         = "\"${each.value.env_prefix}\""
    env_environment    = "\"${each.value.env_environment}\""
    env_name           = "\"${each.value.env_name}\""
    env_vpc_name       = "\"${each.value.env_vpc_name}\""
    env_subnetwork     = "\"${each.value.env_subnetwork}\""
    env_subnet_ip      = "\"${each.value.env_subnet_ip}\""
    env_vpn_cidr_block = "\"${each.value.env_vpn_cidr_block}\""
  }
}

resource "local_file" "terraform_env" {
  for_each = var.projects
  content  = data.template_file.terraform_env[each.key].rendered
  filename = "${local.zimagi_repo}/zimagi-gke/terraform/env/${each.key}.tfvars"
}

data "template_file" "terraform_backend_config" {
  for_each = var.projects
  template = file("${path.module}/templates/backend_config.tf.tpl")
  vars = {
    backend_config_bucket = "\"${each.value.backend_config_bucket}\""
    backend_config_prefix = "\"/terraform-gcp/${each.key}.tfsate\""
  }
}

resource "local_file" "terraform_backend_config" {
  for_each = var.projects
  content  = data.template_file.terraform_backend_config[each.key].rendered
  filename = "${local.zimagi_repo}/zimagi-gke/terraform/backend_configs/${each.key}.tf"
}

data "template_file" "helm_main" {
  template = file("${path.module}/templates/helm/main.tf.tpl")
}

resource "local_file" "helm_main" {
  content  = data.template_file.helm_main.rendered
  filename = "${local.zimagi_repo}/zimagi-gke/helm/main.tf"
}

data "template_file" "helm_backend_config" {
  for_each = var.projects
  template = file("${path.module}/templates/backend_config.tf.tpl")
  vars = {
    backend_config_bucket = "\"${each.value.backend_config_bucket}\""
    backend_config_prefix = "\"/terraform-helm/${each.key}.tfsate\""
  }
}

resource "local_file" "helm_backend_config" {
  for_each = var.projects
  content  = data.template_file.helm_backend_config[each.key].rendered
  filename = "${local.zimagi_repo}/zimagi-gke/helm/backend_configs/${each.key}.tf"
}

data "template_file" "helm_env" {
  for_each = var.projects
  template = file("${path.module}/templates/helm/env.tfvars.tpl")
  vars = {
    cluster_name     = "\"${each.value.cluster_name}\""
    default_location = "\"${each.value.default_location}\""
    project_id       = "\"${each.value.env_project_id}\""
  }
}

resource "local_file" "helm_env" {
  for_each = var.projects
  content  = data.template_file.helm_env[each.key].rendered
  filename = "${local.zimagi_repo}/zimagi-gke/helm/env/${each.key}.tfvars"
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
  filename = "${local.zimagi_repo}/zimagi-gke/cloudbuild-tf-apply.yaml"
}

data "template_file" "argocd_values" {
  template = file("${path.module}/templates/helm/argocd_values.yaml.tpl")
  vars     = {}
}

resource "local_file" "argocd_values" {
  content  = data.template_file.argocd_values.rendered
  filename = "${local.zimagi_repo}/zimagi-gke/helm/argocd_values.yaml"
}

data "template_file" "argocd_apps_values" {
  template = file("${path.module}/templates/helm/argocd_apps_values.yaml.tpl")
  vars     = {}
}

resource "local_file" "argocd_apps_values" {
  content  = data.template_file.argocd_apps_values.rendered
  filename = "${local.zimagi_repo}/zimagi-gke/helm/argocd_apps_values.yaml"
}