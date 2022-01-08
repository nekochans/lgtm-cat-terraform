data "archive_file" "lambda_function" {
  type        = "zip"
  source_dir  = "${path.module}/function"
  output_path = "${path.module}/function/lambda.zip"
}

data "aws_region" "current" {}

resource "aws_lambda_function" "api" {
  filename         = data.archive_file.lambda_function.output_path
  source_code_hash = data.archive_file.lambda_function.output_base64sha256
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_api.arn
  handler          = "lambda"
  runtime          = "go1.x"

  memory_size = 128
  timeout     = 29

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.lambda.id]
  }

  environment {
    variables = {
      REGION                 = data.aws_region.current.name
      UPLOAD_S3_BUCKET_NAME  = var.s3_bucket_name
      LGTM_IMAGES_CDN_DOMAIN = var.lgtm_images_cdn_domain
      DB_HOSTNAME            = var.db_hostname
      DB_PASSWORD            = var.db_password
      DB_USERNAME            = var.db_username
      DB_NAME                = var.db_name
    }
  }

  lifecycle {
    ignore_changes = [
      last_modified,
      source_code_hash,
      version,
    ]
  }
}

resource "aws_cloudwatch_log_group" "api" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = var.log_retention_in_days
}

resource "aws_security_group" "lambda" {
  name        = "${var.lambda_function_name}-lambda"
  description = "${var.lambda_function_name} Lambda Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.lambda_function_name}-lambda"
  }
}

resource "aws_security_group_rule" "lambda_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lambda.id
}
