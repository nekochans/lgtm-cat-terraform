locals {
  env                                     = "stg"
  user_pool_name                          = "${local.env}-lgtmeow-user-pool"
  user_pool_domain_name                   = "${local.env}-lgtmeow"
  email_identity_arn                      = data.terraform_remote_state.ses.outputs.email_identity_arn
  lgtm_cat_api_resource_server_name       = "${local.env}-lgtm-cat-api"
  lgtm_cat_api_resource_server_identifier = "api.lgtmeow"
  lgtm_cat_bff_client_name                = "lgtmeow-bff"
}
