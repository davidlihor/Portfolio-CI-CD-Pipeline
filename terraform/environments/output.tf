output "github_actions_role_arn" {
  value       = aws_iam_role.github_actions_role.arn
  description = "Copy this ARN and put it in the AWS_ROLE_ARN secret in GitHub"
}
