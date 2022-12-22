# terraform-google-zimagi-factory
This module allows you to prepare Google Cloud Platform project for Zimagi cluster.

Role prereqs:

- roles/resourcemanager.projectCreator -> executor of terraform

## Deploy

Terraform first deploy google environment such as projects, cloudbuild, cloud source, vpcs, vpn:

1. Copy template folder from path `examples/template` to a new folder in the examples
2. Fill out `fixtures.tfvars`
* Optionally you can add more input and output parameter

    * add input: put any input parameter from section Inputs into `main.tf` file

    * add output: put any output parameters from section Outpust into `outputs.tf` file

3. Run next commands:

    * terraform init

    * terraform validate

    * terraform apply -var-file=fixtures.tfvars

Create OAUTH client for sso aithentiication:

1. Choose project seed

2. Navigate to `API & Services`

3. Click on OAUTH consent screen and fill out the form

4. Click on Credentials

5. Create a new oauth web application oauth credentials use URI redirect with callback url: <nginx_host>/oauth2/callback

6. Save client id and secret for the next section

Regenerate values file

1. Add client id and secret to `fixutes.tfvars` file

2. Run next commands:

    * terraform init

    * terraform validate

    * terraform apply -var-file=fixtures.tfvars

Clone cloud sourece repo then change directory that repo and deploy environment

1. Copy all content from the zimagi-gke folder in the specific example folder

2. Create branch develop: `git checkout -b develop`

3. Commit all changes and push them against the branch

Deploy production environment

1. Create branch main: `git checkout -b main`

2. Commit all changes and push them against the branch


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.50 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 3.50 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bootstrap_build"></a> [bootstrap\_build](#module\_bootstrap\_build) | ./modules/terraform-google-bootstrap-cloudbuild | n/a |
| <a name="module_bootstrap_seed"></a> [bootstrap\_seed](#module\_bootstrap\_seed) | ./modules/terraform-google-bootstrap-project | n/a |
| <a name="module_cloud-nat"></a> [cloud-nat](#module\_cloud-nat) | terraform-google-modules/cloud-nat/google | 2.2.1 |
| <a name="module_generate_zimagi_gke_repo"></a> [generate\_zimagi\_gke\_repo](#module\_generate\_zimagi\_gke\_repo) | ./modules/terraform-local-file-repo | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-google-modules/network/google | 5.0.0 |
| <a name="module_vpn"></a> [vpn](#module\_vpn) | ./modules/terraform-google-vpn-ha | n/a |
| <a name="module_worker_pool"></a> [worker\_pool](#module\_worker\_pool) | ./modules/terraform-google-private-pool | n/a |
| <a name="module_zimagi_projects"></a> [zimagi\_projects](#module\_zimagi\_projects) | terraform-google-modules/project-factory/google | 13.0.0 |

## Resources

| Name | Type |
|------|------|
| [google_compute_global_address.nginx_address](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_compute_router.router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_folder_iam_member.folder_cb_sa_browser](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_member) | resource |
| [google_folder_iam_member.org_cb_sa_iam_viewer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_member) | resource |
| [google_project.cloudbuild](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_activate_build_apis"></a> [activate\_build\_apis](#input\_activate\_build\_apis) | List of APIs to enable in the Cloudbuild project. | `list(string)` | `[]` | no |
| <a name="input_activate_seed_apis"></a> [activate\_seed\_apis](#input\_activate\_seed\_apis) | List of APIs to enable in the seed project. | `list(string)` | `[]` | no |
| <a name="input_bgp_session_range"></a> [bgp\_session\_range](#input\_bgp\_session\_range) | n/a | `string` | `"30"` | no |
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | The ID of the billing account to associate projects with. | `string` | n/a | yes |
| <a name="input_build_project_id"></a> [build\_project\_id](#input\_build\_project\_id) | Custom project ID to use for project created. If not supplied, the default id is {project\_prefix}-seed-{random suffix}. | `string` | `""` | no |
| <a name="input_build_project_labels"></a> [build\_project\_labels](#input\_build\_project\_labels) | Labels to apply to the project. | `map(string)` | `{}` | no |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | n/a | `any` | n/a | yes |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | n/a | `any` | n/a | yes |
| <a name="input_cloud_source_repos"></a> [cloud\_source\_repos](#input\_cloud\_source\_repos) | List of Cloud Source Repos to create with CloudBuild triggers. | `list(string)` | `[]` | no |
| <a name="input_cloudbuild_apply_filename"></a> [cloudbuild\_apply\_filename](#input\_cloudbuild\_apply\_filename) | Path and name of Cloud Build YAML definition used for terraform apply. | `string` | `"cloudbuild-tf-apply.yaml"` | no |
| <a name="input_cloudbuild_plan_filename"></a> [cloudbuild\_plan\_filename](#input\_cloudbuild\_plan\_filename) | cloudbuild-tf-plan.yaml | `string` | `"cloudbuild-tf-plan.yaml"` | no |
| <a name="input_create_cloud_source_repos"></a> [create\_cloud\_source\_repos](#input\_create\_cloud\_source\_repos) | If shared Cloud Source Repos should be created.If shared Cloud Source Repos should be created. | `bool` | `true` | no |
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | Default region to create resources where applicable. | `string` | n/a | yes |
| <a name="input_enable_cross_project_service_account_usage"></a> [enable\_cross\_project\_service\_account\_usage](#input\_enable\_cross\_project\_service\_account\_usage) | n/a | `bool` | `true` | no |
| <a name="input_enable_force_destroy"></a> [enable\_force\_destroy](#input\_enable\_force\_destroy) | If supplied, the state bucket will be deleted even while containing objects. | `bool` | `false` | no |
| <a name="input_enable_random_suffix"></a> [enable\_random\_suffix](#input\_enable\_random\_suffix) | Appends a 4 character random suffix to project ID and GCS bucket name. | `bool` | `true` | no |
| <a name="input_encrypt_gcs_bucket_tfstate"></a> [encrypt\_gcs\_bucket\_tfstate](#input\_encrypt\_gcs\_bucket\_tfstate) | Encrypt bucket used for storing terraform state files in seed project. | `bool` | `false` | no |
| <a name="input_extra_org_project_creators"></a> [extra\_org\_project\_creators](#input\_extra\_org\_project\_creators) | Additional list of members to have project creator role accross the organization. Prefix of group: user: or serviceAccount: is required. | `list(string)` | `[]` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | The ID of a folder to host this project | `string` | `null` | no |
| <a name="input_gar_repo_name"></a> [gar\_repo\_name](#input\_gar\_repo\_name) | Custom name to use for GAR repo. | `string` | `""` | no |
| <a name="input_gcloud_version"></a> [gcloud\_version](#input\_gcloud\_version) | Default gcloud image version. | `string` | `""` | no |
| <a name="input_group_billing_admins"></a> [group\_billing\_admins](#input\_group\_billing\_admins) | Google Group for GCP Billing Administrators | `string` | `""` | no |
| <a name="input_group_org_admins"></a> [group\_org\_admins](#input\_group\_org\_admins) | Google Group for GCP Organization Administrators | `string` | `""` | no |
| <a name="input_kubernetes_cluster_name"></a> [kubernetes\_cluster\_name](#input\_kubernetes\_cluster\_name) | n/a | `any` | n/a | yes |
| <a name="input_maintainer_email"></a> [maintainer\_email](#input\_maintainer\_email) | n/a | `any` | n/a | yes |
| <a name="input_master_ipv4_cidr_block"></a> [master\_ipv4\_cidr\_block](#input\_master\_ipv4\_cidr\_block) | n/a | `string` | `"172.16.0.0/28"` | no |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | GCP Organization ID | `string` | n/a | yes |
| <a name="input_parent_folder"></a> [parent\_folder](#input\_parent\_folder) | GCP parent folder ID in the form folders/{id} | `string` | `""` | no |
| <a name="input_pool_name"></a> [pool\_name](#input\_pool\_name) | n/a | `any` | n/a | yes |
| <a name="input_project_prefix"></a> [project\_prefix](#input\_project\_prefix) | Name prefix to use for projects created. | `string` | `null` | no |
| <a name="input_sa_enable_impersonation"></a> [sa\_enable\_impersonation](#input\_sa\_enable\_impersonation) | Allow org\_admins group to impersonate service account & enable APIs required. | `bool` | `false` | no |
| <a name="input_seed_project_id"></a> [seed\_project\_id](#input\_seed\_project\_id) | Custom project ID to use for project created. If not supplied, the default id is {project\_prefix}-seed-{random suffix}. | `string` | `""` | no |
| <a name="input_seed_project_labels"></a> [seed\_project\_labels](#input\_seed\_project\_labels) | Labels to apply to the project. | `map(string)` | `{}` | no |
| <a name="input_state_bucket_name"></a> [state\_bucket\_name](#input\_state\_bucket\_name) | Custom state bucket name. If not supplied, the default name is {project\_prefix}-tfstate-{random suffix}. | `string` | `""` | no |
| <a name="input_storage_bucket_labels"></a> [storage\_bucket\_labels](#input\_storage\_bucket\_labels) | Labels to apply to the storage bucket. | `map(string)` | `{}` | no |
| <a name="input_tf_service_account_id"></a> [tf\_service\_account\_id](#input\_tf\_service\_account\_id) | ID of service account for terraform in seed project | `string` | `"org-terraform"` | no |
| <a name="input_tf_service_account_name"></a> [tf\_service\_account\_name](#input\_tf\_service\_account\_name) | Display name of service account for terraform in seed project | `string` | `"Organization Terraform Account"` | no |
| <a name="input_users_folder_admin"></a> [users\_folder\_admin](#input\_users\_folder\_admin) | n/a | `list(string)` | `[]` | no |
| <a name="input_users_org_admins"></a> [users\_org\_admins](#input\_users\_org\_admins) | n/a | `list` | `[]` | no |
| <a name="input_vpn_shared_secret"></a> [vpn\_shared\_secret](#input\_vpn\_shared\_secret) | n/a | `string` | `"secret"` | no |
| <a name="input_zimagi_projects"></a> [zimagi\_projects](#input\_zimagi\_projects) | Zimagi Projects | `map` | <pre>{<br>  "develop": {<br>    "activate_apis": [<br>      "container.googleapis.com",<br>      "servicenetworking.googleapis.com",<br>      "cloudbuild.googleapis.com",<br>      "compute.googleapis.com"<br>    ],<br>    "enable_private_endpoint": false,<br>    "enable_private_nodes": false,<br>    "enable_random_suffix": true,<br>    "name": "development",<br>    "project_labels": {}<br>  },<br>  "production": {<br>    "activate_apis": [<br>      "container.googleapis.com",<br>      "servicenetworking.googleapis.com",<br>      "cloudbuild.googleapis.com",<br>      "compute.googleapis.com"<br>    ],<br>    "enable_private_endpoint": false,<br>    "enable_private_nodes": false,<br>    "enable_random_suffix": true,<br>    "name": "production",<br>    "project_labels": {}<br>  }<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudbuild_project_id"></a> [cloudbuild\_project\_id](#output\_cloudbuild\_project\_id) | Project where CloudBuild configuration and terraform container image will reside. |
| <a name="output_csr_repos"></a> [csr\_repos](#output\_csr\_repos) | List of Cloud Source Repos created by the module, linked to Cloud Build triggers. |
| <a name="output_gcs_bucket_cloudbuild_artifacts"></a> [gcs\_bucket\_cloudbuild\_artifacts](#output\_gcs\_bucket\_cloudbuild\_artifacts) | Bucket used to store Cloud/Build artifacts in CloudBuild project. |
| <a name="output_gcs_bucket_cloudbuild_logs"></a> [gcs\_bucket\_cloudbuild\_logs](#output\_gcs\_bucket\_cloudbuild\_logs) | Bucket used to store Cloud/Build logs in CloudBuild project. |
| <a name="output_gcs_bucket_tfstate"></a> [gcs\_bucket\_tfstate](#output\_gcs\_bucket\_tfstate) | Bucket used for storing terraform state for foundations pipelines in seed project. |
| <a name="output_seed_project_id"></a> [seed\_project\_id](#output\_seed\_project\_id) | Project where service accounts and core APIs will be enabled. |
| <a name="output_terraform_sa_email"></a> [terraform\_sa\_email](#output\_terraform\_sa\_email) | Email for privileged service account for Terraform. |
| <a name="output_terraform_sa_name"></a> [terraform\_sa\_name](#output\_terraform\_sa\_name) | Fully qualified name for privileged service account for Terraform. |
| <a name="output_tf_runner_artifact_repo"></a> [tf\_runner\_artifact\_repo](#output\_tf\_runner\_artifact\_repo) | GAR Repo created to store runner images |
| <a name="output_zimagi_project_ids"></a> [zimagi\_project\_ids](#output\_zimagi\_project\_ids) | n/a |