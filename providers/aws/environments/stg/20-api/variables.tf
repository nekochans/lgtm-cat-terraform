locals {
  env = "stg"

  lambda_function_name       = "${local.env}-lgtm-cat-api"
  lambda_api_iam_policy_name = "${local.env}-lgtm-cat-api-policy"
  lambda_api_iam_role_name   = "${local.env}-lgtm-cat-api-role"
  log_retention_in_days      = 3

  api_gateway_name          = "${local.env}-lgtm-cat-api"
  auto_deploy               = true
  api_gateway_domain_name   = "${local.env}-api.${var.main_domain_name}"
  certificate_arn           = data.terraform_remote_state.acm.outputs.ap_northeast_1_sub_domain_acm_arn
  jwt_authorizer_name       = "${local.env}-jwt-authorizer"
  jwt_authorizer_issuer_url = "https://${data.terraform_remote_state.cognito.outputs.idp_endpoint}"
  lgtm_cat_bff_client_id    = data.terraform_remote_state.cognito.outputs.lgtm_cat_bff_client_id

  image_recognition_api_gateway_id          = jsondecode(data.aws_secretsmanager_secret_version.image_recognition_secret.secret_string)["api_id"]
  image_recognition_api_gateway_domain_name = "${local.env}-image-recognition-api.${var.main_domain_name}"

  db_password = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["db_app_password"]
  db_username = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["db_app_user"]
  db_name     = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["db_name"]
  db_hostname = "lgtm-cat-rds-proxy.${local.env}"
}


locals {
  name                      = "${local.env}-lgtm-cat-api"
  ecs_domain_name           = "${local.env}-ecs-api.${var.main_domain_name}"
  enable_container_insights = false
  ecs_service_desired_count = 1
  ecs_task_cpu              = 256
  ecs_task_memory           = 512
}

variable "main_domain_name" {
  type    = string
  default = "lgtmeow.com"
}

data "aws_route53_zone" "api" {
  name = var.main_domain_name
}

data "aws_secretsmanager_secret" "secret" {
  name = "/stg/lgtm-cat"
}

data "aws_secretsmanager_secret_version" "secret" {
  secret_id = data.aws_secretsmanager_secret.secret.id
}

variable "api_allow_origins" {
  type    = list(string)
  default = ["https://*", "http://localhost:2222"]
}

data "aws_secretsmanager_secret" "image_recognition_secret" {
  name = "/stg/lgtm-cat/image-recognition"
}

data "aws_secretsmanager_secret_version" "image_recognition_secret" {
  secret_id = data.aws_secretsmanager_secret.image_recognition_secret.id
}
