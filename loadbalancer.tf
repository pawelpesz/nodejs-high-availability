resource "aws_security_group" "http" {
    name        = "http"
    description = "Allow HTTP through load balancer"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        description = "HTTP access"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        description = "To Internet"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}

resource "aws_lb" "loadbalancer" {
    name = "${var.base_name}-loadbalancer"
    load_balancer_type = "application"
    internal = false
    security_groups = [ aws_security_group.http.id ]
    subnets = aws_subnet.subnet[*].id
}

resource "aws_lb_target_group" "target" {
    name     = "${var.base_name}-target"
    protocol = "HTTP"
    port     = 3000
    vpc_id   = aws_vpc.vpc.id
    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout  = 3
        interval = 30
        protocol = "HTTP"
        port     = var.app_port
        path     = "/"
        matcher  = "200"
    }
}

resource "aws_lb_listener" "listener" {
    load_balancer_arn = aws_lb.loadbalancer.arn
    protocol          = "HTTP"
    port              = 80
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.target.arn
    }
}
