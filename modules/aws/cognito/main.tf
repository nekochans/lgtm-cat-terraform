resource "aws_cognito_user_pool" "user_pool" {
  name                     = var.user_pool_name
  auto_verified_attributes = ["email"]

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  username_attributes = ["email", "phone_number"]

  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  mfa_configuration = "OPTIONAL"

  software_token_mfa_configuration {
    enabled = true
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_message        = "検証コードは {####} です。"
    email_subject        = "検証コード"
    sms_message          = "検証コードは {####} です。"
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  email_configuration {
    source_arn            = var.email_identity_arn
    email_sending_account = "DEVELOPER"
  }
}

resource "aws_cognito_user_pool_domain" "user_pool_domain" {
  domain       = var.user_pool_domain_name
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

// https://github.com/nekochans/lgtm-cat-api に定義されているAPIはこのscopeによって保護する
resource "aws_cognito_resource_server" "lgtm_cat_api" {
  name       = var.lgtm_cat_api_resource_server_name
  identifier = var.lgtm_cat_api_resource_server_identifier

  scope {
    scope_description = "lgtm-cat-apiに定義されているAPIを全て利用出来る権限。"
    scope_name        = "all"
  }

  user_pool_id = aws_cognito_user_pool.user_pool.id
}

// https://github.com/nekochans/lgtm-cat-image-recognition に定義されているAPIはこのscopeによって保護する
resource "aws_cognito_resource_server" "lgtm_cat_image_recognition_api" {
  name       = var.lgtm_cat_image_recognition_api_resource_server_name
  identifier = var.lgtm_cat_image_recognition_api_resource_server_identifier

  scope {
    scope_description = "lgtm-cat-image-recognitionに定義されているAPIを全て利用出来る権限。"
    scope_name        = "all"
  }

  user_pool_id = aws_cognito_user_pool.user_pool.id
}

// https://github.com/nekochans/lgtm-cat-frontend のサーバーサイド部分でのみ利用する
resource "aws_cognito_user_pool_client" "lgtm_cat_bff_client" {
  name                          = var.lgtm_cat_bff_client_name
  user_pool_id                  = aws_cognito_user_pool.user_pool.id
  generate_secret               = true
  prevent_user_existence_errors = "ENABLED"

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["client_credentials"]
  allowed_oauth_scopes                 = ["${aws_cognito_resource_server.lgtm_cat_api.identifier}/all", "${aws_cognito_resource_server.lgtm_cat_image_recognition_api.identifier}/all"]

  depends_on = [aws_cognito_resource_server.lgtm_cat_api]
}
