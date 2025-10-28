data "aws_iam_policy_document" "ecs_scale_assume_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["chatbot.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_scale" {
  name               = "${var.name}-ecs-scale-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_scale_assume_role.json
}

data "aws_iam_policy_document" "ecs_scale" {
  statement {
    sid    = "AllowUpdateEcsService"
    effect = "Allow"

    actions = [
      "ecs:UpdateService",
      "ecs:DescribeServices",
      "ecs:ListServices",
      "ecs:DescribeClusters"
    ]

    resources = [
      "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/${var.env}-lgtm-cat-api",
      "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:service/${var.env}-lgtm-cat-api/${var.env}-lgtm-cat-api"
    ]
  }
}

resource "aws_iam_policy" "ecs_scale" {
  name   = "${var.name}-ecs-scale-policy"
  policy = data.aws_iam_policy_document.ecs_scale.json
}

resource "aws_iam_role_policy_attachment" "ecs_scale_attach" {
  role       = aws_iam_role.ecs_scale.name
  policy_arn = aws_iam_policy.ecs_scale.arn
}
