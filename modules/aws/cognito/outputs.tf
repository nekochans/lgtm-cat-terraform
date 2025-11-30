output "idp_endpoint" {
  value = aws_cognito_user_pool.user_pool.endpoint
}

output "lgtm_cat_bff_client_id" {
  value = aws_cognito_user_pool_client.lgtm_cat_bff_client.id
}

output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.user_pool.id
}

output "cognito_app_client_id" {
  value = aws_cognito_user_pool_client.lgtm_cat_bff_client.id
}

output "cognito_client_secret" {
  value     = aws_cognito_user_pool_client.lgtm_cat_bff_client.client_secret
  sensitive = true
}

output "cognito_token_endpoint" {
  value = "https://${var.user_pool_domain_name}.auth.${data.aws_region.current.id}.amazoncognito.com/oauth2/token"
}
