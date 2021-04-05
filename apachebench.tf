resource "null_resource" "apachebench" {
    triggers = {
        always_run = timestamp()
    }
    provisioner "local-exec" {
        command = "ab -n ${var.test_requests} -c ${var.test_concurrency} -r -q http://${aws_elb.loadbalancer.dns_name}${var.app_test_url}"
    }
    depends_on = [
        aws_autoscaling_group.autoscaling_group,
        aws_cloudwatch_metric_alarm.low_cpu,
        aws_cloudwatch_metric_alarm.high_cpu
    ]
}
