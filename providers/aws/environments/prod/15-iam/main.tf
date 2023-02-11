module "iam" {
  source                      = "../../../../../modules/aws/iam"
  serverless_deploy_user_name = local.serverless_deploy_user_name
}

module "identity_provider" {
  source = "../../../../../modules/aws/iam/identity-provider"
}
