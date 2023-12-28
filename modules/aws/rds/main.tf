resource "aws_rds_cluster" "rds_cluster" {
  cluster_identifier              = "${var.rds_name}-cluster"
  master_username                 = var.master_username
  master_password                 = var.master_password
  backup_retention_period         = 5
  preferred_backup_window         = "19:30-20:00"
  skip_final_snapshot             = true
  storage_encrypted               = false
  vpc_security_group_ids          = [aws_security_group.rds_cluster.id, aws_security_group.rds_cluster_stg.id]
  preferred_maintenance_window    = "wed:20:15-wed:20:45"
  db_subnet_group_name            = aws_db_subnet_group.rds_subnet_group.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.rds_cluster_parameter_group.name
  engine                          = var.engine
  engine_version                  = var.engine_version
  availability_zones              = var.cluster_availability_zones

  lifecycle {
    ignore_changes = [availability_zones]
  }
}

resource "aws_rds_cluster_instance" "rds_cluster_instance" {
  for_each                = toset(var.instance_availability_zones)
  cluster_identifier      = aws_rds_cluster.rds_cluster.id
  instance_class          = var.instance_class
  engine                  = var.engine
  engine_version          = var.engine_version
  identifier              = "${var.rds_name}-${index(var.instance_availability_zones, each.value) + 1}"
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  db_parameter_group_name = aws_db_parameter_group.rds_parameter_group.name
  monitoring_role_arn     = aws_iam_role.rds_monitoring_role.arn
  monitoring_interval     = 60
  availability_zone       = each.value
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.rds_name}-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_parameter_group" "rds_parameter_group" {
  name   = "${var.rds_name}-parameter-group"
  family = var.parameter_group_family

  parameter {
    name  = "long_query_time"
    value = "0.1"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }
}

resource "aws_rds_cluster_parameter_group" "rds_cluster_parameter_group" {
  name   = "${var.rds_name}-cluster-parameter-group"
  family = var.parameter_group_family

  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_connection"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_filesystem"
    value = "binary"
  }

  parameter {
    name  = "character_set_results"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "collation_connection"
    value = "utf8mb4_0900_bin"
  }

  parameter {
    name  = "collation_server"
    value = "utf8mb4_0900_bin"
  }

  parameter {
    name  = "time_zone"
    value = "Asia/Tokyo"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_security_group" "rds_cluster" {
  name        = "${var.rds_name}-rds"
  description = "${var.rds_name}-rds Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.rds_name}-rds"
  }
}

resource "aws_security_group_rule" "rds_egress" {
  security_group_id = aws_security_group.rds_cluster.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "rds_ingress_bastion" {
  security_group_id        = aws_security_group.rds_cluster.id
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_ecs.id
}

resource "aws_security_group_rule" "rds_from_rds_proxy" {
  security_group_id        = aws_security_group.rds_cluster.id
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.rds_proxy.id
}

resource "aws_security_group_rule" "rds_from_ecs" {
  security_group_id        = aws_security_group.rds_cluster.id
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  source_security_group_id = var.api_ecs_securitygroup_id
}

resource "aws_security_group_rule" "rds_from_lambda" {
  security_group_id        = aws_security_group.rds_cluster.id
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  source_security_group_id = var.lambda_securitygroup_id
}

resource "aws_security_group_rule" "rds_from_migration" {
  security_group_id        = aws_security_group.rds_cluster.id
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  source_security_group_id = var.migration_ecs_securitygroup_id
}

resource "aws_security_group" "rds_cluster_stg" {
  name        = "stg-${var.rds_name}-rds"
  description = "${var.rds_name}-rds Security Group for stg"
  vpc_id      = var.vpc_id

  tags = {
    Name = "stg-${var.rds_name}-rds"
  }
}

resource "aws_security_group_rule" "rds_egress_stg" {
  security_group_id = aws_security_group.rds_cluster_stg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "rds_from_rds_proxy_stg" {
  security_group_id        = aws_security_group.rds_cluster_stg.id
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.rds_proxy_stg.id
}

resource "aws_security_group_rule" "rds_from_ecs_stg" {
  security_group_id        = aws_security_group.rds_cluster_stg.id
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  source_security_group_id = var.stg_api_ecs_securitygroup_id
}

resource "aws_security_group_rule" "rds_from_lambda_stg" {
  security_group_id        = aws_security_group.rds_cluster_stg.id
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  source_security_group_id = var.stg_lambda_securitygroup_id
}

resource "aws_security_group_rule" "rds_from_migration_stg" {
  security_group_id        = aws_security_group.rds_cluster_stg.id
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  source_security_group_id = var.stg_migration_ecs_securitygroup_id
}
