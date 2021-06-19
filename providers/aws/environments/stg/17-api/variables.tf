locals {
  env = "stg"

  lambda_function_name       = "${local.env}-lgtm-cat-api"
  lambda_api_iam_policy_name = "${local.env}-lgtm-cat-api-policy"
  lambda_api_iam_role_name   = "${local.env}-lgtm-cat-api-role"
  log_retention_in_days      = 3

  api_gateway_name        = "${local.env}-lgtm-cat-api"
  auto_deploy             = true
  api_gateway_domain_name = "${local.env}-api.${var.main_domain_name}"
  certificate_arn         = data.terraform_remote_state.acm.outputs.ap_northeast_1_sub_domain_acm_arn
}

variable "main_domain_name" {
  type    = string
  default = "lgtmeow.com"
}

data "aws_route53_zone" "api" {
  name = var.main_domain_name
}
