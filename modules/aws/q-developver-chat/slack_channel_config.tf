resource "aws_chatbot_slack_channel_configuration" "ecs_scale" {
  configuration_name    = "${var.name}-ecs-scale"
  iam_role_arn          = aws_iam_role.ecs_scale.arn
  slack_channel_id      = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["ecs_scale_slack_channel_id"]
  slack_team_id         = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["amazon_q_developer_slack_workspace_id"]
  guardrail_policy_arns = [aws_iam_policy.ecs_scale.arn]
}
