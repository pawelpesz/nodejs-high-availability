terraform {
  required_version = "~> 1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.62"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = ">= 2.3"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.4"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9"
    }
  }
  cloud {
    workspaces {
      name = "nodejs-high-availability"
    }
  }
}
