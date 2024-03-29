variable "org_id" {
  type        = string
  description = "GCP Organization ID"
}

variable "folder_id" {
  type        = string
  default     = null
  description = "The ID of a folder to host this project"
}

variable "parent_folder" {
  type        = string
  default     = ""
  description = "GCP parent folder ID in the form folders/{id}"
}

variable "enable_random_suffix" {
  type        = bool
  default     = true
  description = "Appends a 4 character random suffix to project ID and GCS bucket name."
}

variable "billing_account" {
  type        = string
  description = "The ID of the billing account to associate projects with."
}


variable "group_billing_admins" {
  type        = string
  description = "Google Group for GCP Billing Administrators"
  default     = ""
}

variable "extra_org_project_creators" {
  type        = list(string)
  default     = []
  description = "Additional list of members to have project creator role accross the organization. Prefix of group: user: or serviceAccount: is required."
}


variable "sa_enable_impersonation" {
  type        = bool
  default     = false
  description = "Allow org_admins group to impersonate service account & enable APIs required."
}


variable "activate_seed_apis" {
  type        = list(string)
  description = "List of APIs to enable in the seed project."
  default     = []
}


variable "seed_project_id" {
  type        = string
  default     = ""
  description = "Custom project ID to use for project created. If not supplied, the default id is {project_prefix}-seed-{random suffix}."
}

variable "project_prefix" {
  type        = string
  default     = null
  description = "Name prefix to use for projects created."
}

variable "state_bucket_name" {
  type        = string
  default     = ""
  description = "Custom state bucket name. If not supplied, the default name is {project_prefix}-tfstate-{random suffix}."
}

variable "encrypt_gcs_bucket_tfstate" {
  type        = bool
  default     = false
  description = "Encrypt bucket used for storing terraform state files in seed project."
}

variable "enable_force_destroy" {
  type        = bool
  default     = false
  description = "If supplied, the state bucket will be deleted even while containing objects."
}


variable "tf_service_account_id" {
  type        = string
  default     = "org-terraform"
  description = "ID of service account for terraform in seed project"
}

variable "tf_service_account_name" {
  type        = string
  default     = "Organization Terraform Account"
  description = "Display name of service account for terraform in seed project"
}

variable "enable_cross_project_service_account_usage" {
  type    = bool
  default = true
}

variable "storage_bucket_labels" {
  type        = map(string)
  default     = {}
  description = "Labels to apply to the storage bucket."
}


variable "seed_project_labels" {
  type        = map(string)
  default     = {}
  description = "Labels to apply to the project."
}

variable "activate_build_apis" {
  type        = list(string)
  default     = []
  description = "List of APIs to enable in the Cloudbuild project."
}

variable "group_org_admins" {
  type        = string
  default     = ""
  description = "Google Group for GCP Organization Administrators"
}


variable "users_folder_admin" {
  default = []
  type    = list(string)
}