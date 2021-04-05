terraform {
    required_version = "~> 0.14"
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 3.35"
        }
        template = {
            source  = "hashicorp/template"
            version = ">= 2.0"
        }
        null = {
            source  = "hashicorp/null"
            version = ">= 3.0"
        }
        local = {
            source  = "hashicorp/local"
            version = ">= 2.0"
        }
    }
}