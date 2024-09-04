resource "aws_cloudwatch_log_group" "lgtm_image_processor" {
  name              = "/aws/lambda/${local.lambda_function_name}"
  retention_in_days = var.log_retention_in_days
}
