terraform {
  required_providers {
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }
}

terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
  }
}