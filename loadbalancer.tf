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

resource "aws_elb" "loadbalancer" {
    name = "${var.base_name}-loadbalancer"
    security_groups = [ aws_security_group.http.id ]
    subnets = aws_subnet.subnet[*].id
    cross_zone_load_balancing = true
    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 3
        target              = "HTTP:${var.app_port}/"
        interval            = 30
    }
    listener {
        instance_port     = var.app_port
        instance_protocol = "http"
        lb_port           = 80
        lb_protocol       = "http"
    }
}