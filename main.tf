resource "aws_autoscaling_group" "autoscaling_group" {
    name = "${var.base_name}-autoscaling-group"

    min_size          = 1
    max_size          = var.autoscaling_max_size
    desired_capacity  = 1
    health_check_type = "ELB"
    load_balancers    = [ aws_elb.loadbalancer.id ]

    vpc_zone_identifier  = aws_subnet.subnet[*].id
    launch_configuration = aws_launch_configuration.instance.name

    enabled_metrics = [
        "GroupMinSize",
        "GroupMaxSize",
        "GroupDesiredCapacity",
        "GroupInServiceInstances",
        "GroupTotalInstances"
    ]
}

resource "aws_autoscaling_policy" "scale_up" {
    name               = "scale_up"
    scaling_adjustment = 1
    adjustment_type    = "ChangeInCapacity"
    cooldown           = 300
    autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
    alarm_name          = "high_cpu"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods  = 1
    metric_name         = "CPUUtilization"
    namespace           = "AWS/EC2"
    period              = 60
    statistic           = "Average"
    threshold           = var.autoscaling_threshold.high

    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.autoscaling_group.name
    }

    alarm_description = "Alarm when CPU utilization > ${var.autoscaling_threshold.high}"
    alarm_actions = [ aws_autoscaling_policy.scale_up.arn ]
}

resource "aws_autoscaling_policy" "scale_down" {
    name               = "scale_down"
    scaling_adjustment = -1
    adjustment_type    = "ChangeInCapacity"
    cooldown           = 300
    autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
    alarm_name          = "low_cpu"
    comparison_operator = "LessThanThreshold"
    evaluation_periods  = 2
    metric_name         = "CPUUtilization"
    namespace           = "AWS/EC2"
    period              = 180
    statistic           = "Average"
    threshold           = var.autoscaling_threshold.low

    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.autoscaling_group.name
    }

    alarm_description = "Alarm when CPU utilization < ${var.autoscaling_threshold.low}"
    alarm_actions = [ aws_autoscaling_policy.scale_down.arn ]
}
