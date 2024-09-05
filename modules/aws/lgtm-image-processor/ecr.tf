resource "aws_ecr_repository" "lgtm_image_processor" {
  name                 = "${var.env}-${var.service_name}"
  image_tag_mutability = "MUTABLE"
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

resource "aws_ecr_lifecycle_policy" "lgtm_image_processor" {
  repository = aws_ecr_repository.lgtm_image_processor.name
  policy     = local.lifecycle_policy
}
