output "github_actions_role_arn" {
  value       = aws_iam_role.github_actions_role.arn
  description = "Copy this ARN and put it in the AWS_ROLE_ARN secret in GitHub"
}

output "cloudfront_distribution_id" {
  value       = module.portfolio_website.cloudfront_distribution_id
  description = "The ID of the CloudFront distribution."
}
