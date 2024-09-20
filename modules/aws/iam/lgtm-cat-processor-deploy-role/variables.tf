variable "github_actions_oidc_provider_arn" {
  type = string
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
