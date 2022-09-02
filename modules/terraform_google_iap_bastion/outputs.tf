output "bastion_name" {
  description = "Name of the bastion host"
  value       = module.bastion.hostname
}

output "bastion_zone" {
  description = "Location of bastion host"
  value       = local.bastion_zone
}

output "bastion_ssh_command" {
  description = "gcloud command to ssh and port forward to the bastion host command"
  value       = format("gcloud beta compute ssh %s --tunnel-through-iap --project %s --zone %s -- -L8888:127.0.0.1:8888", module.bastion.hostname, var.project_id, local.bastion_zone)
}

output "bastion_kubectl_command" {
  description = "kubectl command using the local proxy once the bastion_ssh command is running"
  value       = "HTTPS_PROXY=localhost:8888 kubectl get pods --all-namespaces"
}