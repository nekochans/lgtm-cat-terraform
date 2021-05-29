module "iam" {
  source                                  = "../../../../../modules/aws/cognito"
  user_pool_name                          = local.user_pool_name
  user_pool_domain_name                   = local.user_pool_domain_name
  email_identity_arn                      = local.email_identity_arn
  lgtm_cat_api_resource_server_name       = local.lgtm_cat_api_resource_server_name
  lgtm_cat_api_resource_server_identifier = local.lgtm_cat_api_resource_server_identifier
  lgtm_cat_bff_client_name                = local.lgtm_cat_bff_client_name
}
