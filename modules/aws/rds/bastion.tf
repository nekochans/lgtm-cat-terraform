resource "aws_ecs_cluster" "bastion" {
  name = "${var.rds_name}-bastion-cluster"

  configuration {
    execute_command_configuration {
      logging = "NONE"
    }
  }
}

data "aws_region" "current" {}

data "template_file" "bastion_template" {
  template = file("${path.module}/task/bastion.json")

  vars = {
    aws_logs_group     = aws_cloudwatch_log_group.bastion.name
    aws_region         = data.aws_region.current.name
    ecr_repository_url = aws_ecr_repository.bastion.repository_url
  }
}

resource "aws_ecs_task_definition" "bastion" {
  family                   = "${var.rds_name}-bastion"
  network_mode             = "awsvpc"
  container_definitions    = data.template_file.bastion_template.rendered
  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.bastion_ecs_task_role.arn
  execution_role_arn       = aws_iam_role.bastion_ecs_task_execution_role.arn
}

resource "aws_ecs_service" "bastion" {
  name                   = "${var.rds_name}-bastion-service"
  cluster                = aws_ecs_cluster.bastion.id
  task_definition        = aws_ecs_task_definition.bastion.arn
  desired_count          = 1
  launch_type            = "FARGATE"
  enable_execute_command = true
  platform_version       = "1.4.0"

  network_configuration {
    subnets          = var.subnet_ids
    assign_public_ip = true

    security_groups = [
      aws_security_group.bastion_ecs.id,
    ]
  }

  deployment_controller {
    type = "ECS"
  }

  lifecycle {
    ignore_changes = [
      desired_count,
    ]
  }
}

resource "aws_security_group" "bastion_ecs" {
  name        = "${var.rds_name}-bastion-ecs"
  description = "${var.rds_name}-bastion-ecs Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.rds_name}-bastion-ecs"
  }
}

resource "aws_security_group_rule" "bastion_ecs_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_ecs.id
}

resource "aws_ecr_repository" "bastion" {
  name = "${var.rds_name}-bastion"
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

resource "aws_ecr_lifecycle_policy" "bastion" {
  repository = aws_ecr_repository.bastion.name
  policy     = local.lifecycle_policy
}

resource "aws_cloudwatch_log_group" "bastion" {
  name              = "${var.rds_name}-bastion"
  retention_in_days = 1
}
