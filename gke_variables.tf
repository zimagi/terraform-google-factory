variable "zimagi_projects" {
  # type = map(string)
  default = {
    production = {
      name = "production"
      activate_apis = [
        "container.googleapis.com",
        "servicenetworking.googleapis.com",
        "cloudbuild.googleapis.com",
        "compute.googleapis.com"
      ]
      project_labels          = {}
      enable_random_suffix    = true
      enable_private_endpoint = true
      enable_private_nodes    = true
    }
    develop = {
      name = "development"
      activate_apis = [
        "container.googleapis.com",
        "servicenetworking.googleapis.com",
        "cloudbuild.googleapis.com",
        "compute.googleapis.com"
      ]
      project_labels          = {}
      enable_random_suffix    = true
      enable_private_endpoint = false
      enable_private_nodes    = false
    }
  }
  description = "Zimagi Projects"
}