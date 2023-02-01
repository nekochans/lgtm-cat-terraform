resource "aws_security_group" "vpc_endpoint" {
  name   = "vpc-endpoint"
  vpc_id = aws_vpc.this.id
}

resource "aws_security_group_rule" "vpc_endpoint_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.this.cidr_block]
  security_group_id = aws_security_group.vpc_endpoint.id
}
