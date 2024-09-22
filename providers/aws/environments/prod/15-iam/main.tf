module "iam" {
  source                      = "../../../../../modules/aws/iam"
  serverless_deploy_user_name = local.serverless_deploy_user_name
}

module "identity_provider" {
  source = "../../../../../modules/aws/iam/identity-provider"
}

module "api_deploy_role" {
  source = "../../../../../modules/aws/iam/api-deploy-role"

  github_actions_oidc_provider_arn = module.identity_provider.github_actions_oidc_provider_arn
}

module "lgtm_cat_processor_deploy_role" {
  source = "../../../../../modules/aws/iam/lgtm-cat-processor-deploy-role"

  github_actions_oidc_provider_arn = module.identity_provider.github_actions_oidc_provider_arn
}
