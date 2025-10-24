resource "aws_ecs_cluster" "api" {
  name = var.name

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }
}

resource "aws_ecs_service" "api" {
  name    = var.name
  cluster = aws_ecs_cluster.api.id
  // タスクの定義は Terraform ではなく lgtm-cat-api リポジトリで管理
  task_definition  = ""
  desired_count    = var.ecs_service_desired_count
  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  load_balancer {
    target_group_arn = aws_alb_target_group.api_public.id
    container_name   = "nginx"
    container_port   = 80
  }

  network_configuration {
    subnets          = var.subnet_public_ids
    assign_public_ip = true

    security_groups = [
      aws_security_group.api_ecs.id,
    ]
  }

  lifecycle {
    ignore_changes = [
      task_definition,
    ]
  }

  depends_on = [aws_alb_listener.api_public]
}

resource "aws_ecs_service" "api_v2" {
  name    = "${var.name}-v2"
  cluster = aws_ecs_cluster.api.id
  // タスクの定義は Terraform ではなく lgtm-cat-api リポジトリで管理
  task_definition  = ""
  desired_count    = var.ecs_service_desired_count
  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  load_balancer {
    target_group_arn = aws_alb_target_group.api_v2_public.id
    container_name   = "nginx"
    container_port   = 80
  }

  network_configuration {
    subnets          = var.subnet_public_ids
    assign_public_ip = true

    security_groups = [
      aws_security_group.api_ecs.id,
    ]
  }

  lifecycle {
    ignore_changes = [
      task_definition,
    ]
  }

  depends_on = [aws_alb_listener.api_public]
}