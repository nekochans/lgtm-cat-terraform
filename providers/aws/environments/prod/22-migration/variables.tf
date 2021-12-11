locals {
  migration_name = "lgtm-cat-migration"
  db_password    = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["db_app_password"]
  db_username    = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["db_app_user"]
  db_name        = "lgtm_cat"
  db_hostname    = "lgtm-cat-rds.stg"
}

data "aws_secretsmanager_secret" "secret" {
  name = "/prod/lgtm-cat"
}

data "aws_secretsmanager_secret_version" "secret" {
  secret_id = data.aws_secretsmanager_secret.secret.id
}
