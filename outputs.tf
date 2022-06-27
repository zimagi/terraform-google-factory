# output "gcs_bucket_tfstate" {
#   value       = module.bootstrap_seed.gcs_bucket_tfstate
#   sensitive   = false
#   description = "Bucket used for storing terraform state for foundations pipelines in seed project."
#   depends_on  = []
# }

# output "seed_project_id" {
#   value       = module.bootstrap_seed.seed_project_id
#   sensitive   = false
#   description = "Project where service accounts and core APIs will be enabled."
#   depends_on  = []
# }

# output "terraform_sa_email" {
#   value       = module.bootstrap_seed.terraform_sa_email
#   sensitive   = false
#   description = "Email for privileged service account for Terraform."
#   depends_on  = []
# }

# output "terraform_sa_name" {
#   value       = module.bootstrap_seed.terraform_sa_name
#   sensitive   = false
#   description = "Fully qualified name for privileged service account for Terraform."
#   depends_on  = []
# }

# output "cloudbuild_project_id" {
#   value       = module.bootstrap_build.cloudbuild_project_id
#   sensitive   = false
#   description = "Project where CloudBuild configuration and terraform container image will reside."
#   depends_on  = []
# }

# output "csr_repos" {
#   value       = module.bootstrap_build.csr_repos
#   sensitive   = false
#   description = "List of Cloud Source Repos created by the module, linked to Cloud Build triggers."
#   depends_on  = []
# }

# output "gcs_bucket_cloudbuild_artifacts" {
#   value       = module.bootstrap_build.gcs_bucket_cloudbuild_artifacts
#   sensitive   = false
#   description = "Bucket used to store Cloud/Build artifacts in CloudBuild project."
#   depends_on  = []
# }

# output "gcs_bucket_cloudbuild_logs" {
#   value       = module.bootstrap_build.gcs_bucket_cloudbuild_logs
#   sensitive   = false
#   description = "Bucket used to store Cloud/Build logs in CloudBuild project."
#   depends_on  = []
# }

# output "tf_runner_artifact_repo" {
#   value       = module.bootstrap_build.tf_runner_artifact_repo
#   sensitive   = false
#   description = "GAR Repo created to store runner images"
#   depends_on  = []
# }
