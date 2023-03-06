resource "aws_ssm_parameter" "db_hostname" {
  name      = "/${var.env}/lgtm-cat/api/DB_HOSTNAME"
  type      = "SecureString"
  value     = var.db_hostname
  overwrite = true
}

resource "aws_ssm_parameter" "db_username" {
  name      = "/${var.env}/lgtm-cat/api/DB_USERNAME"
  type      = "SecureString"
  value     = var.db_username
  overwrite = true
}

resource "aws_ssm_parameter" "db_name" {
  name      = "/${var.env}/lgtm-cat/api/DB_NAME"
  type      = "SecureString"
  value     = var.db_name
  overwrite = true
}

resource "aws_ssm_parameter" "db_password" {
  name      = "/${var.env}/lgtm-cat/api/DB_PASSWORD"
  type      = "SecureString"
  value     = var.db_password
  overwrite = true
}

resource "aws_ssm_parameter" "sentry_dsn" {
  name      = "/${var.env}/lgtm-cat/api/SENTRY_DSN"
  type      = "SecureString"
  value     = var.sentry_dsn
  overwrite = true
}

resource "aws_ssm_parameter" "cognito_user_pool_id" {
  name      = "/${var.env}/lgtm-cat/api/COGNITO_USER_POOL_ID"
  type      = "SecureString"
  value     = var.cognito_user_pool_id
  overwrite = true
}
