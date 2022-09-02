variable "prefix" {
  type        = string
  description = "The name of the prefix"
}

variable "region" {
  type        = string
  description = "The region to host the cluster in"
}

variable "network" {
  type        = string
  description = "The name of the network being created to host the cluster in"
}

variable "subnet" {
  type        = string
  description = "The name of the subnet being created to host the cluster in"
}

variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in"
}

variable "bastion_members" {
  type        = list(string)
  description = "List of users, groups, SAs who need access to the bastion host"
}