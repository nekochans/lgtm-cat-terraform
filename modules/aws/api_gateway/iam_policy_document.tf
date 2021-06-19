data "aws_iam_policy_document" "api_policy" {
  statement {
    effect = "Allow"
    principals {
      type = "*"
      identifiers = [
      "*"]
    }
    actions = [
      "execute-api:Invoke"
    ]
    resources = [
      "arn:aws:execute-api:ap-northeast-1:*:*/*/*"
    ]
  }
}


