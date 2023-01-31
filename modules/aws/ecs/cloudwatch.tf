resource "aws_cloudwatch_log_group" "api_app_log" {
  name              = "${var.name}-app"
  retention_in_days = var.log_retention_in_days
}

resource "aws_cloudwatch_log_group" "api_nginx_log" {
  name              = "${var.name}-nginx"
  retention_in_days = var.log_retention_in_days
}