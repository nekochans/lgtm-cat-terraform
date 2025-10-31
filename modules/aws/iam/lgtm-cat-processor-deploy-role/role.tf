data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [var.github_actions_oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:nekochans/lgtm-cat-processor:*"]
    }
  }
}

resource "aws_iam_role" "deploy" {
  name               = "lgtm-cat-processor-deploy-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "deploy" {
  name = "lgtm-cat-processor-deploy-policy"
  policy = templatefile("${path.module}/files/policy.json", {
    region     = data.aws_region.current.id
    account_id = data.aws_caller_identity.current.account_id
  })
}

resource "aws_iam_role_policy_attachment" "deploy" {
  role       = aws_iam_role.deploy.name
  policy_arn = aws_iam_policy.deploy.arn
}
