resource "aws_db_proxy" "rds_proxy" {
  name                   = "${var.rds_name}-rds-proxy"
  debug_logging          = false
  engine_family          = "MYSQL"
  idle_client_timeout    = 120
  require_tls            = false
  role_arn               = aws_iam_role.rds_proxy_role.arn
  vpc_security_group_ids = [aws_security_group.rds_proxy.id, aws_security_group.rds_proxy_stg.id]
  vpc_subnet_ids         = var.subnet_ids

  auth {
    auth_scheme = "SECRETS"
    iam_auth    = "DISABLED"
    secret_arn  = aws_secretsmanager_secret.rds_connection.arn
  }

  auth {
    auth_scheme = "SECRETS"
    iam_auth    = "DISABLED"
    secret_arn  = aws_secretsmanager_secret.rds_connection_stg.arn
  }

  depends_on = [aws_rds_cluster.rds_cluster, aws_secretsmanager_secret_version.rds_connection]
}

resource "aws_db_proxy_default_target_group" "rds_proxy" {
  db_proxy_name = aws_db_proxy.rds_proxy.name

  connection_pool_config {
    connection_borrow_timeout    = 120
    max_connections_percent      = 100
    max_idle_connections_percent = 50
  }
}

resource "aws_db_proxy_target" "rds_proxy" {
  db_cluster_identifier = aws_rds_cluster.rds_cluster.id
  db_proxy_name         = aws_db_proxy.rds_proxy.name
  target_group_name     = aws_db_proxy_default_target_group.rds_proxy.name
}

resource "aws_security_group" "rds_proxy" {
  name        = "${var.rds_name}-rds-proxy"
  description = "${var.rds_name} RDS Proxy Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.rds_name}-rds-proxy"
  }
}

resource "aws_security_group_rule" "rds_proxy_egress" {
  security_group_id = aws_security_group.rds_proxy.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "rds_proxy_from_bastion_server" {
  security_group_id        = aws_security_group.rds_proxy.id
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_ecs.id
}

resource "aws_security_group_rule" "rds_from_lambda" {
  security_group_id        = aws_security_group.rds_proxy.id
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  source_security_group_id = var.lambda_securitygroup_id
}

resource "aws_security_group_rule" "rds_from_api_lambda" {
  security_group_id        = aws_security_group.rds_proxy.id
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  source_security_group_id = var.api_lambda_securitygroup_id
}

resource "aws_security_group" "rds_proxy_stg" {
  name        = "stg-${var.rds_name}-rds-proxy"
  description = "${var.rds_name} RDS Proxy Security Group for stg"
  vpc_id      = var.vpc_id

  tags = {
    Name = "stg-${var.rds_name}-rds-proxy"
  }
}

resource "aws_security_group_rule" "rds_proxy_egress_stg" {
  security_group_id = aws_security_group.rds_proxy_stg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "rds_from_stg_lambda" {
  security_group_id        = aws_security_group.rds_proxy_stg.id
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  source_security_group_id = var.stg_lambda_securitygroup_id
}

resource "aws_security_group_rule" "rds_from_stg_api_lambda" {
  security_group_id        = aws_security_group.rds_proxy_stg.id
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  source_security_group_id = var.stg_api_lambda_securitygroup_id
}
