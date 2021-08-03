resource "aws_ecr_repository" "migration" {
  name = var.migration_name
}

locals {
  lifecycle_policy = <<EOF
  {
    "rules": [
      {
        "rulePriority": 10,
        "description": "Expire images count more than 10",
        "selection": {
          "tagStatus": "any",
          "countType": "imageCountMoreThan",
          "countNumber": 10
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
EOF
}

resource "aws_ecr_lifecycle_policy" "migration" {
  repository = aws_ecr_repository.migration.name
  policy     = local.lifecycle_policy
}

resource "aws_ecs_cluster" "migration" {
  name = "${var.migration_name}-cluster"
}

resource "aws_cloudwatch_log_group" "migration" {
  name              = var.migration_name
  retention_in_days = 1
}

resource "aws_security_group" "migration_ecs" {
  name        = "${var.migration_name}-ecs"
  description = "${var.migration_name}-ecs Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.migration_name}-ecs"
  }
}

resource "aws_security_group_rule" "migration_ecs_egress" {
  security_group_id = aws_security_group.migration_ecs.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
