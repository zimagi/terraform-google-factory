timeout: 1200s
steps:
# terraform init
- name: hashicorp/terraform:light
  args:
  - init
  - -input=false
  - -backend-config=backend_configs/$BRANCH_NAME.tf
  dir: $_TERRAFORM_GCP_DIR
# terraform validate
- name: hashicorp/terraform:light
  args:
  - validate
  dir: $_TERRAFORM_GCP_DIR
# terraform plan -input=false -out=tfplan
- name: hashicorp/terraform:light
  args:
  - plan
  - -input=false
  - -out=tfplan
  - -var-file=env/$BRANCH_NAME.tfvars
  dir: $_TERRAFORM_GCP_DIR
# terraform apply -auto-approve -input=false tfplan
- name: hashicorp/terraform:light
  args:
  - apply
  - -auto-approve
  - -input=false
  - tfplan
  dir: $_TERRAFORM_GCP_DIR
artifacts:
  objects:
    location: 'gs://$${_ARTIFACT_BUCKET_NAME}/terraform/cloudbuild/apply/$BUILD_ID'
    paths: ['cloudbuild-tf-apply.yaml', 'tfplan']
options:
  workerPool:
    'projects/${cloudbuild_project_id}/locations/${cloudbuild_region}/workerPools/zimagi-gke-pool'
  logging: CLOUD_LOGGING_ONLY
  env: ["TF_CLI_ARGS=-no-color", "TF_VAR_enable_vpc=false"]
