resource "aws_lambda_function" "lgtm_image_processor" {
  function_name = var.lambda_function_name
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.lgtm_image_processor.repository_url}:latest"
  role          = aws_iam_role.lambda.arn

  architectures = ["arm64"]
  memory_size   = 256
  timeout       = 180

  environment {
    variables = {
      JUDGE_IMAGE_UPLOAD_BUCKET         = var.judge_image_upload_bucket
      GENERATE_LGTM_IMAGE_UPLOAD_BUCKET = var.generate_lgtm_image_upload_bucket
      VECTOR_INDEX_BUCKET               = var.vector_index_bucket
      VECTOR_INDEX_NAME                 = var.vector_index_name
      DB_HOSTNAME                       = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["db_host"]
      DB_USERNAME                       = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["db_app_user"]
      DB_PASSWORD                       = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["db_app_password"]
      DB_NAME                           = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["db_name"]
      JUDGE_IMAGE_API_URL               = var.judge_image_api_url
      COGNITO_CLIENT_ID                 = var.cognito_client_id
      COGNITO_CLIENT_SECRET             = var.cognito_client_secret
      COGNITO_TOKEN_ENDPOINT            = var.cognito_token_endpoint
    }
  }

  lifecycle {
    ignore_changes = [
      image_uri,
    ]
  }
}
