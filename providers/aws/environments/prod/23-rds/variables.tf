locals {
  rds_name                    = "lgtm-cat"
  engine                      = "aurora-mysql"
  engine_version              = "8.0.mysql_aurora.3.01.0"
  master_password             = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["db_master_password"]
  master_username             = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["db_master_user"]
  instance_class              = "db.t4g.medium"
  instance_count              = 1
  parameter_group_family      = "aurora-mysql8.0"
  cluster_availability_zones  = ["ap-northeast-1a", "ap-northeast-1c"]
  instance_availability_zones = ["ap-northeast-1a"]
  proxy_engine                = "mysql"
  app_password                = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["db_app_password"]
  app_username                = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["db_app_user"]
  rds_domain_name             = "lgtm-cat-rds"
  rds_proxy_domain_name       = "lgtm-cat-rds-proxy"

  // stg
  stg_app_password = jsondecode(data.aws_secretsmanager_secret_version.secret_stg.secret_string)["db_app_password"]
  stg_app_username = jsondecode(data.aws_secretsmanager_secret_version.secret_stg.secret_string)["db_app_user"]
}

data "aws_secretsmanager_secret" "secret" {
  name = "/prod/lgtm-cat"
}

data "aws_secretsmanager_secret_version" "secret" {
  secret_id = data.aws_secretsmanager_secret.secret.id
}

data "aws_secretsmanager_secret" "secret_stg" {
  name = "/stg/lgtm-cat"
}

data "aws_secretsmanager_secret_version" "secret_stg" {
  secret_id = data.aws_secretsmanager_secret.secret_stg.id
}
