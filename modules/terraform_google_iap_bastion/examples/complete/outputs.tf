output "bastion_name" {
  description = "Name of the bastion host"
  value       = module.iap_bastion.bastion_name
}

output "bastion_zone" {
  description = "Location of bastion host"
  value       = module.iap_bastion.bastion_zone
}

output "bastion_ssh_command" {
  description = "gcloud command to ssh and port forward to the bastion host command"
  value       = module.iap_bastion.bastion_ssh_command
}

output "bastion_kubectl_command" {
  description = "kubectl command using the local proxy once the bastion_ssh command is running"
  value       = module.iap_bastion.bastion_kubectl_command
}