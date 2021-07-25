// RDS Monitoring Role
data "aws_iam_policy_document" "rds_monitoring_policy" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "rds_monitoring_role" {
  name               = "rds-monitoring"
  assume_role_policy = data.aws_iam_policy_document.rds_monitoring_policy.json
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_attachment" {
  role       = aws_iam_role.rds_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

// RDS Proxy Role
data "aws_iam_policy_document" "rds_proxy_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "rds_proxy_role" {
  name               = "rds-proxy-role"
  assume_role_policy = data.aws_iam_policy_document.rds_proxy_assume_role.json
}

data "aws_iam_policy_document" "rds_proxy_role" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = [
      "arn:aws:secretsmanager:*:*:*",
    ]
  }
}

resource "aws_iam_role_policy" "rds_proxy_policy" {
  name   = "rds-proxy-policy"
  role   = aws_iam_role.rds_proxy_role.id
  policy = data.aws_iam_policy_document.rds_proxy_role.json
}
