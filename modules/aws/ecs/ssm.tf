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
