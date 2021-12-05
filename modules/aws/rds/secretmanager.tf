resource "aws_secretsmanager_secret" "rds_connection" {
  name = "${var.rds_name}/rds-connection"
}

resource "aws_secretsmanager_secret_version" "rds_connection" {
  secret_id = aws_secretsmanager_secret.rds_connection.id

  secret_string = jsonencode({
    username : var.app_username
    password : var.app_password
    engine : var.proxy_engine
    host : aws_rds_cluster.rds_cluster.endpoint
    port : aws_rds_cluster.rds_cluster.port
    dbClusterIdentifier : aws_rds_cluster.rds_cluster.id
  })
}

resource "aws_secretsmanager_secret" "rds_connection_stg" {
  name = "/stg/${var.rds_name}/rds-connection"
}

resource "aws_secretsmanager_secret_version" "rds_connection_stg" {
  secret_id = aws_secretsmanager_secret.rds_connection_stg.id

  secret_string = jsonencode({
    username : var.stg_app_username
    password : var.stg_app_password
    engine : var.proxy_engine
    host : aws_rds_cluster.rds_cluster.endpoint
    port : aws_rds_cluster.rds_cluster.port
    dbClusterIdentifier : aws_rds_cluster.rds_cluster.id
  })
}
