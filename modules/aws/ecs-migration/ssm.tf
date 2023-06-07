resource "aws_ssm_parameter" "db_hostname" {
  name  = "/${var.env}/lgtm-cat/migration/DB_HOSTNAME"
  type  = "SecureString"
  value = var.db_hostname
}

resource "aws_ssm_parameter" "db_username" {
  name  = "/${var.env}/lgtm-cat/migration/DB_USERNAME"
  type  = "SecureString"
  value = var.db_username
}

resource "aws_ssm_parameter" "db_name" {
  name  = "/${var.env}/lgtm-cat/migration/DB_NAME"
  type  = "SecureString"
  value = var.db_name
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/${var.env}/lgtm-cat/migration/DB_PASSWORD"
  type  = "SecureString"
  value = var.db_password
}
