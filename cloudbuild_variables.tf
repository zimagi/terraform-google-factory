variable "cloudbuild_apply_filename" {
  type        = string
  default     = "cloudbuild-tf-apply.yaml"
  description = "Path and name of Cloud Build YAML definition used for terraform apply."
}

variable "cloudbuild_plan_filename" {
  type        = string
  default     = "cloudbuild-tf-plan.yaml"
  description = "cloudbuild-tf-plan.yaml"
}

variable "create_cloud_source_repos" {
  type        = bool
  default     = true
  description = "If shared Cloud Source Repos should be created.If shared Cloud Source Repos should be created."
}

variable "gar_repo_name" {
  type        = string
  default     = ""
  description = "Custom name to use for GAR repo."
}

variable "gcloud_version" {
  type        = string
  default     = ""
  description = "Default gcloud image version."
}


variable "build_project_id" {
  type        = string
  default     = ""
  description = "Custom project ID to use for project created. If not supplied, the default id is {project_prefix}-seed-{random suffix}."
}

variable "build_project_labels" {
  type        = map(string)
  default     = {}
  description = "Labels to apply to the project."
}