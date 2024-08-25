module "lgtm_image_processor" {
  source = "../../../../../modules/aws/lgtm-image-processor"

  ecr_name              = local.ecr_name
  lambda_function_name  = local.lambda_function_name
  lambda_iam_role_name  = local.lambda_iam_role_name
  log_retention_in_days = local.log_retention_in_days
}
