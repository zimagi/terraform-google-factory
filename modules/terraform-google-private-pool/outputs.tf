# output "id" {
#   value       = .id
#   description = "Identifier for the resource with format projects/{{project}}/locations/{{location}}/workerPools/{{name}}."
#   sensitive   = false
# }

# output "state" {
#   value       = .state
#   description = "WorkerPool state. Possible values: STATE_UNSPECIFIED, PENDING, APPROVED, REJECTED, CANCELLED."
#   sensitive   = false
# }

output "network_id" {
  value = google_compute_network.default.id
}

output "network_self_link" {
  value = google_compute_network.default.self_link
}

output "vpc_cidr" {
  value = "${var.global_address}/${var.global_address_prefix_length}"
}