module "api_gateway" {
  source = "../../../../../modules/aws/api-gateway"

  zone_id                                   = data.aws_route53_zone.api.zone_id
  certificate_arn                           = local.certificate_arn
  image_recognition_api_gateway_id          = local.image_recognition_api_gateway_id
  image_recognition_api_gateway_domain_name = local.image_recognition_api_gateway_domain_name
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
  upload_images_bucket_name = data.terraform_remote_state.images.outputs.upload_images_bucket_name
  db_hostname               = local.db_hostname
  db_name                   = local.db_name
  db_password               = local.db_password
  db_username               = local.db_username
  sentry_dsn                = local.sentry_dsn
  cognito_user_pool_id      = data.terraform_remote_state.cognito.outputs.cognito_user_pool_id
}
