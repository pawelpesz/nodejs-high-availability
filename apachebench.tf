resource "time_sleep" "initial_delay" {
  create_duration = var.test_initial_delay
  depends_on = [
    aws_autoscaling_group.autoscaling_group,
    aws_cloudwatch_metric_alarm.low_cpu,
    aws_cloudwatch_metric_alarm.high_cpu,
    aws_lb.loadbalancer
  ]
}

resource "null_resource" "apachebench" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-CMD
      curl -s -o ab ${var.apachebench_url} && \
      chmod 0755 ab && \
      ./ab -n ${var.test_requests} -c ${var.test_concurrency} -r -q http://${aws_lb.loadbalancer.dns_name}${var.app_test_url}
    CMD
  }
  depends_on = [time_sleep.initial_delay]
}
