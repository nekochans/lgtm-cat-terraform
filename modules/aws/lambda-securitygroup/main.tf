resource "aws_security_group" "lambda" {
  name        = "${var.lambda_function_name}-lambda"
  description = "${var.lambda_function_name} Lambda Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.lambda_function_name}-lambda"
  }
}

resource "aws_security_group_rule" "lambda_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lambda.id
}
