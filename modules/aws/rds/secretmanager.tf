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
