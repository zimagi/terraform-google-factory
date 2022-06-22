terraform {
  required_version = ">= 0.13"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.50"
    }
  }

  provider_meta "google" {
    module_name = "blueprints/terraform/terraform-example-foundation:bootstrap/v2.3.1"
  }

}