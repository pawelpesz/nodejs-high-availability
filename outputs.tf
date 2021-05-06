output "app_url" {
    value = "http://${aws_lb.loadbalancer.dns_name}"
}