# Variables with defaults below
variable "region" {
  type    = string
  default = "eu-north-1"
}

variable "vpc_cidr" {
  type    = string
  default = "192.168.66.0/24"
}

variable "base_name" {
  type    = string
  default = "nodejsapp"
}

variable "ubuntu" {
  type    = string
  default = "ubuntu-jammy-22.04-amd64-server"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "app_repository_url" {
  type    = string
  default = "https://github.com/nodejs/examples.git"
}

variable "app_directory" {
  type    = string
  default = "servers/express/api-with-express-and-handlebars"
}

variable "app_port" {
  type    = number
  default = 3000
}

variable "app_test_url" {
  type    = string
  default = "/api/latest-releases"
}

variable "autoscaling_max_size" {
  type    = number
  default = 8
}

variable "autoscaling_threshold" {
  type = object({
    low  = number,
    high = number
  })
  default = {
    low  = 20
    high = 60
  }
}

variable "apachebench_url" {
  type    = string
  default = "https://raw.githubusercontent.com/pawelpesz/nodejs-high-availability/main/ab"
}

variable "test_initial_delay" {
  type    = string
  default = "30s"
}

variable "test_concurrency" {
  type    = number
  default = 100
}

variable "test_requests" {
  type    = number
  default = 100000
}
