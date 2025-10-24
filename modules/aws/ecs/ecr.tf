resource "aws_ecr_repository" "api_app" {
  name                 = "${var.name}-app"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_repository" "api_nginx" {
  name                 = "${var.name}-nginx"
  image_tag_mutability = "IMMUTABLE"
}

locals {
  lifecycle_policy = <<EOF
  {
    "rules": [
      {
        "rulePriority": 10,
        "description": "Expire images count more than 5",
        "selection": {
          "tagStatus": "any",
          "countType": "imageCountMoreThan",
          "countNumber": 5
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
EOF

}

resource "aws_ecr_lifecycle_policy" "api_app" {
  repository = aws_ecr_repository.api_app.name
  policy     = local.lifecycle_policy
}

resource "aws_ecr_lifecycle_policy" "api_nginx" {
  repository = aws_ecr_repository.api_nginx.name
  policy     = local.lifecycle_policy
}


resource "aws_ecr_repository" "api_v2_app" {
  name = "${var.name}-v2-app"
  # CDの構築後にIMMUTABLEに変更する
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "api_v2_nginx" {
  name = "${var.name}-v2-nginx"
  # CDの構築後にIMMUTABLEに変更する
  image_tag_mutability = "MUTABLE"
}


resource "aws_ecr_lifecycle_policy" "api_v2_app" {
  repository = aws_ecr_repository.api_v2_app.name
  policy     = local.lifecycle_policy
}

resource "aws_ecr_lifecycle_policy" "api_v2_nginx" {
  repository = aws_ecr_repository.api_v2_nginx.name
  policy     = local.lifecycle_policy
}
