project_id = "zimagi-cloudbuild-835b"

region = "europe-west2"

zone = "europe-west2-b"

num_instances = "1"

service_account = {
  email  = "org-terraform@zimagi-seed-cb2d.iam.gserviceaccount.com"
  scopes = ["cloud-platform"]
}

network_name = "zimagi-gke-pool"
