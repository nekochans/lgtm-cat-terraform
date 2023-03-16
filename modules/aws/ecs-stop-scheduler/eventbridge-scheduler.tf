resource "aws_scheduler_schedule_group" "stop_ecs" {
  count = var.env != "prod" ? 1 : 0

  name = "${var.env}-stop-ecs-group"
}

resource "aws_scheduler_schedule" "stop_ecs" {
  for_each = { for i in var.ecs_targets : i.cluster => i }

  name       = "${var.env}-stop-ecs-${each.value.service}"
  group_name = aws_scheduler_schedule_group.stop_ecs[0].name
  state      = "ENABLED"

  schedule_expression_timezone = "Asia/Tokyo"
  schedule_expression          = "cron(0 3 * * ? *)"

  flexible_time_window {
    mode                      = "FLEXIBLE"
    maximum_window_in_minutes = 10
  }

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:ecs:updateService"
    role_arn = aws_iam_role.ecs_stop_scheduler[0].arn

    input = jsonencode({
      "Cluster" : each.value.cluster,
      "Service" : each.value.service,
      "DesiredCount" : 0
    })

    retry_policy {
      maximum_event_age_in_seconds = 3600
      maximum_retry_attempts       = 3
    }
  }
}
