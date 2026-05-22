output "s3_bucket_id" {
  description = "The name of the S3 bucket hosting the static website."
  value       = module.s3-bucket.s3_bucket_id
}

output "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution."
  value       = aws_cloudfront_distribution.portfolio.id
}