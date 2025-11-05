resource "aws_ssm_parameter" "db_hostname" {
  name  = "/${var.env}/lgtm-cat/api/DB_HOSTNAME"
  type  = "SecureString"
  value = var.db_hostname
}

resource "aws_ssm_parameter" "db_username" {
  name  = "/${var.env}/lgtm-cat/api/DB_USERNAME"
  type  = "SecureString"
  value = var.db_username
}

resource "aws_ssm_parameter" "db_name" {
  name  = "/${var.env}/lgtm-cat/api/DB_NAME"
  type  = "SecureString"
  value = var.db_name
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/${var.env}/lgtm-cat/api/DB_PASSWORD"
  type  = "SecureString"
  value = var.db_password
}

resource "aws_ssm_parameter" "sentry_dsn" {
  name  = "/${var.env}/lgtm-cat/api/SENTRY_DSN"
  type  = "SecureString"
  value = var.sentry_dsn
}

resource "aws_ssm_parameter" "cognito_user_pool_id" {
  name  = "/${var.env}/lgtm-cat/api/COGNITO_USER_POOL_ID"
  type  = "SecureString"
  value = var.cognito_user_pool_id
}

resource "aws_ssm_parameter" "cognito_app_client_id" {
  name  = "/${var.env}/lgtm-cat/api/COGNITO_APP_CLIENT_ID"
  type  = "SecureString"
  value = var.cognito_app_client_id
}

resource "aws_ssm_parameter" "image_allowed_domain" {
  name  = "/${var.env}/lgtm-cat/api/IMAGE_ALLOWED_DOMAIN"
  type  = "SecureString"
  value = var.image_allowed_domain
}
