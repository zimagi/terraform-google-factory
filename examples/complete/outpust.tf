# output "tunnels_1" {
#   value = module.zimagi_factory.tunnels_1
#   sensitive = true
# }

# output "tunnels_2" {
#   value = module.zimagi_factory.tunnels_2
#   sensitive = true

# }

# output "tunnel_names_1" {
#   value = module.zimagi_factory.tunnel_names_1
#   sensitive = true

# }

# output "tunnel_names_2" {
#   value = module.zimagi_factory.tunnel_names_2
#   sensitive = true

# }

output "s" {
  value = module.zimagi_factory.seed_project_id
}

output "c" {
  value = module.zimagi_factory.cloudbuild_project_id
}

output "z" {
  value = module.zimagi_factory.zimagi_project_ids
}

output "g" {
  value = module.zimagi_factory.gcs_bucket_tfstate
}