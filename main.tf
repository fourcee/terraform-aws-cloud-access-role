data "aws_iam_policy_document" "trust_policy" {
  statement {
    effect  = "Allow"
    actions = var.trusted_sts_actions

    principals {
      type        = "AWS"
      identifiers = var.trusted_principal_arns
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = var.iam_role_name
  path                 = var.role_path
  assume_role_policy   = data.aws_iam_policy_document.trust_policy.json
  max_session_duration = var.max_session_duration_seconds
  tags                 = var.tags
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.managed_policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_iam_policy" "custom" {
  for_each = { for p in var.custom_policies : p.name => p }

  name        = each.value.name
  description = each.value.description
  policy      = each.value.policy_json
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "custom" {
  for_each = { for p in var.custom_policies : p.name => p }

  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.custom[each.key].arn
}
