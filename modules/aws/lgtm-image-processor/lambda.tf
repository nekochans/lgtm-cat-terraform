resource "aws_lambda_function" "lgtm_image_processor" {
  function_name = local.lambda_function_name
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.lgtm_image_processor.repository_url}:latest"
  role          = aws_iam_role.lambda.arn

  architectures = ["arm64"]
  memory_size   = 128
  timeout       = 30

  environment {
    variables = {
      JUDGE_IMAGE_UPLOAD_BUCKET         = var.judge_image_upload_bucket
      GENERATE_LGTM_IMAGE_UPLOAD_BUCKET = var.generate_lgtm_image_upload_bucket
      CONVERT_TO_WEBP_UPLOAD_BUCKET     = var.convert_to_webp_upload_bucket
      DB_HOSTNAME                       = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["db_host"]
      DB_USERNAME                       = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["db_app_user"]
      DB_PASSWORD                       = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["db_app_password"]
      DB_NAME                           = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["db_name"]
    }
  }

  lifecycle {
    ignore_changes = [
      last_modified,
      image_uri,
      version,
    ]
  }
}
