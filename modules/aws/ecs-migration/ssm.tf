resource "aws_ssm_parameter" "db_hostname" {
  name      = "/lgtm-cat/migration/DB_HOSTNAME"
  type      = "SecureString"
  value     = var.db_hostname
  overwrite = true
}

resource "aws_ssm_parameter" "db_username" {
  name      = "/lgtm-cat/migration/DB_USERNAME"
  type      = "SecureString"
  value     = var.db_username
  overwrite = true
}

resource "aws_ssm_parameter" "db_name" {
  name      = "/lgtm-cat/migration/DB_NAME"
  type      = "SecureString"
  value     = var.db_name
  overwrite = true
}

resource "aws_ssm_parameter" "db_password" {
  name      = "/lgtm-cat/migration/DB_PASSWORD"
  type      = "SecureString"
  value     = var.db_password
  overwrite = true
}
