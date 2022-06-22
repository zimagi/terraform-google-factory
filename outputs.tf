# output "seed_project_id" {
#   description = "Project where service accounts and core APIs will be enabled."
#   value       = module.project_build.seed_project_id
# }

# output "terraform_service_account" {
#   description = "Email for privileged service account for Terraform."
#   value       = module.project_build.terraform_sa_email
# }

# output "terraform_sa_name" {
#   description = "Fully qualified name for privileged service account for Terraform."
#   value       = module.project_build.terraform_sa_name
# }

# output "gcs_bucket_tfstate" {
#   description = "Bucket used for storing terraform state for foundations pipelines in seed project."
#   value       = module.project_build.gcs_bucket_tfstate
# }

# output "cloudbuild_project_id" {
#   description = "Project where CloudBuild configuration and terraform container image will reside."
#   value       = module.project_cloudbuild.cloudbuild_project_id
# }

# output "gcs_bucket_cloudbuild_artifacts" {
#   description = "Bucket used to store Cloud/Build artifacts in CloudBuild project."
#   value       = module.project_cloudbuild.gcs_bucket_cloudbuild_artifacts
# }

# output "csr_repos" {
#   description = "List of Cloud Source Repos created by the module, linked to Cloud Build triggers."
#   value       = module.project_cloudbuild.csr_repos
# }

# output "terraform_validator_policies_repo" {
#   description = "Cloud Source Repository created for terraform-validator policies."
#   value       = google_sourcerepo_repository.gcp_policies
# }
