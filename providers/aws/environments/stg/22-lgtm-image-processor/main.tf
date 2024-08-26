module "lgtm_image_processor" {
  source = "../../../../../modules/aws/lgtm-image-processor"

  ecr_name                      = local.ecr_name
  lambda_function_name          = local.lambda_function_name
  lambda_iam_role_name          = local.lambda_iam_role_name
  log_retention_in_days         = local.log_retention_in_days
  stepfunctions_name            = local.stepfunctions_name
  stepfunctions_iam_policy_name = local.stepfunctions_iam_policy_name
  stepfunctions_iam_role_name   = local.stepfunctions_iam_role_name
}
