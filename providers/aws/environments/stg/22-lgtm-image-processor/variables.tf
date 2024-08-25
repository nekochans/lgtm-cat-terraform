locals {
  env = "stg"

  ecr_name              = "${local.env}-lgtm-image-processor"
  lambda_function_name  = "${local.env}-lgtm-image-processor"
  lambda_iam_role_name  = "${local.env}-lgtm-image-processor-lambda-role"
  log_retention_in_days = 3
}
