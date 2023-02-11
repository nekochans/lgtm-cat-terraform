data "aws_iam_policy_document" "api_deploy_assume_role" {
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
      values   = ["repo:nekochans/lgtm-cat-api:*"]
    }
  }
}

resource "aws_iam_role" "api_deploy" {
  name               = "api-deploy-role"
  assume_role_policy = data.aws_iam_policy_document.api_deploy_assume_role.json
}

resource "aws_iam_policy" "api_deploy" {
  name = "api-deploy-policy"
  policy = templatefile("${path.module}/files/api-deploy-policy.json", {
    region     = data.aws_region.current.name
    account_id = data.aws_caller_identity.current.account_id
  })
}

resource "aws_iam_role_policy_attachment" "api_deploy" {
  role       = aws_iam_role.api_deploy.name
  policy_arn = aws_iam_policy.api_deploy.arn
}
