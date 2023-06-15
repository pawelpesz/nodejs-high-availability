output "app_url" {
  description = "Application URL"
  value       = "http://${aws_lb.loadbalancer.dns_name}"
}
