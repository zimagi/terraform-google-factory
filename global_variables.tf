variable "default_region" {
  type        = string
  description = "Default region to create resources where applicable."
}

variable "cloud_source_repos" {
  type        = list(string)
  default     = []
  description = "List of Cloud Source Repos to create with CloudBuild triggers."
}

variable "kubernetes_cluster_name" {
}

variable "pool_name" {

}