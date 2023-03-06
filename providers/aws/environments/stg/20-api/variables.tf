locals {
  env = "stg"

  certificate_arn                           = data.terraform_remote_state.acm.outputs.ap_northeast_1_sub_domain_acm_arn
  image_recognition_api_gateway_id          = jsondecode(data.aws_secretsmanager_secret_version.image_recognition_secret.secret_string)["api_id"]
  image_recognition_api_gateway_domain_name = "${local.env}-image-recognition-api.${var.main_domain_name}"
}

locals {
  name                      = "${local.env}-lgtm-cat-api"
  ecs_domain_name           = "${local.env}-api.${var.main_domain_name}"
  enable_container_insights = false
  ecs_service_desired_count = 1
  log_retention_in_days     = 3

  sentry_dsn  = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["sentry_dsn"]
  db_password = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["db_app_password"]
  db_username = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["db_app_user"]
  db_name     = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["db_name"]
  db_hostname = "lgtm-cat-rds-proxy.${local.env}"
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

data "aws_secretsmanager_secret" "image_recognition_secret" {
  name = "/stg/lgtm-cat/image-recognition"
}

data "aws_secretsmanager_secret_version" "image_recognition_secret" {
  secret_id = data.aws_secretsmanager_secret.image_recognition_secret.id
}
