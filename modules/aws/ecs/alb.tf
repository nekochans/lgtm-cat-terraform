resource "aws_alb" "api_public" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.api_public_alb.id]

  subnets = var.subnet_public_ids
}

resource "aws_alb_target_group" "api_public" {
  name        = var.name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/health-checks"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    interval            = 20
    matcher             = 200
  }
}

resource "aws_alb_listener" "api_public" {
  default_action {
    target_group_arn = aws_alb_target_group.api_public.id
    type             = "forward"
  }

  load_balancer_arn = aws_alb.api_public.id
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = var.certificate_arn
}