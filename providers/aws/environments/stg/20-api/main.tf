module "lambda" {
  source = "../../../../../modules/aws/lambda"

  lambda_function_name       = local.lambda_function_name
  lambda_api_iam_policy_name = local.lambda_api_iam_policy_name
  lambda_api_iam_role_name   = local.lambda_api_iam_role_name
  log_retention_in_days      = local.log_retention_in_days
  s3_bucket_name             = data.terraform_remote_state.images.outputs.upload_images_bucket_name
  lgtm_images_cdn_domain     = data.terraform_remote_state.images.outputs.lgtm_images_cdn_domain
  vpc_id                     = data.terraform_remote_state.network.outputs.vpc_id
  subnet_ids                 = data.terraform_remote_state.network.outputs.subnet_public_ids
  db_hostname                = local.db_hostname
  db_name                    = local.db_name
  db_password                = local.db_password
  db_username                = local.db_username
}

module "api_gateway" {
  source = "../../../../../modules/aws/api-gateway"

  lambda_function_name                      = module.lambda.lambda_function_name
  lambda_invoke_arn                         = module.lambda.lambda_invoke_arn
  lambda_arn                                = module.lambda.lambda_arn
  api_gateway_name                          = local.api_gateway_name
  api_gateway_domain_name                   = local.api_gateway_domain_name
  auto_deploy                               = local.auto_deploy
  certificate_arn                           = local.certificate_arn
  zone_id                                   = data.aws_route53_zone.api.zone_id
  jwt_authorizer_name                       = local.jwt_authorizer_name
  jwt_authorizer_issuer_url                 = local.jwt_authorizer_issuer_url
  lgtm_cat_bff_client_id                    = local.lgtm_cat_bff_client_id
  api_allow_origins                         = var.api_allow_origins
  image_recognition_api_gateway_id          = local.image_recognition_api_gateway_id
  image_recognition_api_gateway_domain_name = local.image_recognition_api_gateway_domain_name
  depends_on                                = [module.lambda]
}

module "ecs" {
  source = "../../../../../modules/aws/ecs"

  env                       = local.env
  vpc_id                    = data.terraform_remote_state.network.outputs.vpc_id
  subnet_public_ids         = data.terraform_remote_state.network.outputs.subnet_public_ids
  certificate_arn           = data.terraform_remote_state.acm.outputs.ap_northeast_1_sub_domain_acm_arn
  ecs_domain_name           = local.ecs_domain_name
  zone_id                   = data.aws_route53_zone.api.zone_id
  name                      = local.name
  enable_container_insights = local.enable_container_insights
  log_retention_in_days     = local.log_retention_in_days
  ecs_service_desired_count = local.ecs_service_desired_count
  ecs_task_cpu              = local.ecs_task_cpu
  ecs_task_memory           = local.ecs_task_memory
  upload_images_bucket_name = data.terraform_remote_state.images.outputs.upload_images_bucket_name
  db_hostname               = local.db_hostname
  db_name                   = local.db_name
  db_password               = local.db_password
  db_username               = local.db_username
  lgtm_images_cdn_domain    = data.terraform_remote_state.images.outputs.lgtm_images_cdn_domain
  sentry_dsn                = local.sentry_dsn
}
