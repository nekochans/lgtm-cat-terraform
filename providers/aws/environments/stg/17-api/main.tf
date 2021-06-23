module "lambda" {
  source = "../../../../../modules/aws/lambda"

  lambda_function_name       = local.lambda_function_name
  lambda_api_iam_policy_name = local.lambda_api_iam_policy_name
  lambda_api_iam_role_name   = local.lambda_api_iam_role_name
  log_retention_in_days      = local.log_retention_in_days
  s3_bucket_name             = data.terraform_remote_state.images.outputs.upload_images_bucket_name
}

module "api_gateway" {
  source = "../../../../../modules/aws/api_gateway"

  lambda_function_name    = module.lambda.lambda_function_name
  lambda_invoke_arn       = module.lambda.lambda_invoke_arn
  lambda_arn              = module.lambda.lambda_arn
  api_gateway_name        = local.api_gateway_name
  api_gateway_domain_name = local.api_gateway_domain_name
  auto_deploy             = local.auto_deploy
  certificate_arn         = local.certificate_arn
  zone_id                 = data.aws_route53_zone.api.zone_id

  depends_on = [module.lambda]
}
