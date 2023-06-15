terraform {
  required_version = "~> 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.3"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = ">= 2.3"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2"
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
