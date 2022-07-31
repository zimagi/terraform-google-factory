project_id = "zimagi-cloudbuild-7a38"

region = "europe-central2"

num_instances = "1"

service_account = {
  email  = "org-terraform@zimagi-seed-516a.iam.gserviceaccount.com"
  scopes = ["cloud-platform"]
}

network_name = "zimagi-gke-pool"