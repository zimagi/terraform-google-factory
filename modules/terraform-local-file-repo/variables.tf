variable "projects" {

}

variable "cloudbuild_project_id" {

}

variable "cloudbuild_region" {

}

variable "zimagi_repo_name" {
  type        = string
  default     = "zimagi-gke"
  description = "Name of terraform backend config file"
}

variable "zimagi_repo_path" {
  type        = string
  default     = "."
  description = "Directory for the terraform backend config file, usually `.`. The default is to create no file."
}