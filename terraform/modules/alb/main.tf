resource "aws_lb" "alb" {
  name = "lab-ELB"
  load_balancer_type = "application"
  internal = false
  subnets = ["${var.public_subnet1_id}", "${var.public_subnet2_id}"]
  security_groups = ["${aws_security_group.alb-securitygroup.id}"]

  enable_cross_zone_load_balancing = true

  tags {
    Name = "LAB ALB"
  }
  # Access Denied for bucket
  /*access_logs {
    bucket  = "${aws_s3_bucket.lb_logs.id}"
    prefix  = "arc-lb"
    enabled = true
  }*/
}

resource "aws_s3_bucket" "lb_logs" {
  bucket = "arclabbucket149"
  acl    = "public-read"

  tags {
    Name        = "My bucket"
    Environment = "Dev"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

#Listeners are assigned a specific port to keep an ear out for incoming traffic
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = "${aws_lb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-2015-05"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    target_group_arn = "${aws_lb_target_group.alb_target_group.arn}"
    type             = "forward"
  }
}

/*resource "aws_lb_listener" "alb_tohttps" {
  load_balancer_arn = "${aws_lb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}*/

resource "aws_lb_listener_rule" "listener_rule" {
  depends_on   = ["aws_lb_target_group.alb_target_group"]
  listener_arn = "${aws_lb_listener.alb_listener.arn}"
  priority     = "100"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.alb_target_group.arn}"
  }
  condition {
    field  = "path-pattern"
    values = ["/demo/*"]
  }
}

resource "aws_lb_target_group" "alb_target_group" {
  name     = "arc-lb-tg"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  tags {
    name = "ARC LB TG"
  }
  /*stickiness {
    type            = "lb_cookie"
    cookie_duration = 1800
    enabled         = "true"
  }
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "${var.target_group_path}"
  }*/
}

/**********************
  ALB Security Group
*********************/
resource "aws_security_group" "alb-securitygroup" {
  vpc_id = "${var.vpc_id}"
  name = "alb"
  description = "security group for load balancer"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "ARC_LAB"
  }
}
