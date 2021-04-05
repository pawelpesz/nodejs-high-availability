output "app_url" {
    value = "http://${aws_elb.loadbalancer.dns_name}"
}