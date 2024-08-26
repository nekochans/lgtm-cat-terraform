locals {
  env          = "stg"
  service_name = "lgtm-image-processor"

  ecr_name              = "${local.env}-${local.service_name}"
  lambda_function_name  = "${local.env}-${local.service_name}"
  lambda_iam_role_name  = "${local.env}-${local.service_name}-lambda-role"
  log_retention_in_days = 3

  stepfunctions_name            = "${local.env}-${local.service_name}-invoke"
  stepfunctions_iam_role_name   = "${local.env}-stepfunctions-${local.service_name}-lambda-invoke-role"
  stepfunctions_iam_policy_name = "${local.env}-stepfunctions-${local.service_name}-lambda-invoke-policy"
}
