output "idp_endpoint" {
  value     = module.cognito.idp_endpoint
  sensitive = true
}

output "lgtm_cat_bff_client_id" {
  value     = module.cognito.lgtm_cat_bff_client_id
  sensitive = true
}

output "cognito_user_pool_id" {
  value     = module.cognito.cognito_user_pool_id
  sensitive = true
}
