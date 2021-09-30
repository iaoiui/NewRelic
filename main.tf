variable "externalID" {
}

variable "aws_account_id_of_newrelic" {
  default = "754728514883"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    condition {
      test = "StringEquals"

      values = [
        var.externalID
      ]

      variable = "sts:ExternalId"
    }

    effect = "Allow"

    principals {
      identifiers = [
        var.aws_account_id_of_newrelic
      ]

      type = "AWS"
    }
  }
}

resource "aws_iam_role" "new_relic" {
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  name               = "NewRelicInfrastructure-Integrations"
}

resource "aws_iam_role_policy_attachment" "read_only_access" {
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  role       = aws_iam_role.new_relic.name
}

resource "aws_iam_role_policy_attachment" "budget" {
  policy_arn = aws_iam_policy.budget.arn
  role       = aws_iam_role.new_relic.name
}

resource "aws_iam_policy" "budget" {
  name        = "budget"
  path        = "/"
  description = "Budget forward policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "budgets:ViewBudget"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
