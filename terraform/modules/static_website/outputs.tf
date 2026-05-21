output "s3_bucket_id" {
  description = "The name of the S3 bucket hosting the static website."
  value       = module.s3-bucket.s3_bucket_id
}
