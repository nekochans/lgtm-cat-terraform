resource "aws_ecs_cluster" "api" {
  name = var.name

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }
}

resource "aws_ecs_task_definition" "api" {
  family       = var.name
  network_mode = "awsvpc"
  container_definitions = templatefile("${path.module}/task/task.json", {
    env                       = var.env
    app_image_url             = aws_ecr_repository.api_app.repository_url
    app_aws_logs_group        = aws_cloudwatch_log_group.api_app_log.name
    nginx_image_url           = aws_ecr_repository.api_nginx.repository_url
    nginx_aws_logs_group      = aws_cloudwatch_log_group.api_nginx_log.name
    aws_region                = data.aws_region.current.name
    db_hostname_arn           = aws_ssm_parameter.db_hostname.arn
    db_password_arn           = aws_ssm_parameter.db_password.arn
    db_username_arn           = aws_ssm_parameter.db_username.arn
    sentry_dsn_arn            = aws_ssm_parameter.sentry_dsn.arn
    db_name_arn               = aws_ssm_parameter.db_name.arn
    upload_images_bucket_name = var.upload_images_bucket_name
    lgtm_images_cdn_domain    = var.lgtm_images_cdn_domain
  })

  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  depends_on = [aws_cloudwatch_log_group.api_app_log]
}

resource "aws_ecs_service" "api" {
  name             = var.name
  cluster          = aws_ecs_cluster.api.id
  task_definition  = aws_ecs_task_definition.api.arn
  desired_count    = var.ecs_service_desired_count
  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  load_balancer {
    target_group_arn = aws_alb_target_group.api_public.id
    container_name   = "nginx"
    container_port   = 80
  }

  network_configuration {
    subnets = var.subnet_public_ids

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
