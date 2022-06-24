terraform {
  required_version = "~> 1.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.20"
    }
    template = {
      source  = "hashicorp/template"
      version = ">= 2.2"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.1"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.2"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.7"
    }
  }
  cloud {
    workspaces {
      name = "nodejs-high-availability"
    }
  }
}
