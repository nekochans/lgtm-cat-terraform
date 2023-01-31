resource "aws_security_group" "api_public_alb" {
  name        = "${var.name}-alb"
  description = "${var.name}-alb"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "api_public_alb_ingress" {
  security_group_id = aws_security_group.api_public_alb.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "api_public_alb_egress" {
  security_group_id = aws_security_group.api_public_alb.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "api_ecs" {
  name   = "${var.name}-ecs"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "api_ecs_egress" {
  security_group_id = aws_security_group.api_ecs.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "bff_ecs_from_alb" {
  security_group_id        = aws_security_group.api_ecs.id
  type                     = "ingress"
  from_port                = "80"
  to_port                  = "80"
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.api_public_alb.id
}

