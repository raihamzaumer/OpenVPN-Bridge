output "bucket_id" {
  value = aws_s3_bucket.this.id
}

output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}

output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "website_endpoint" {
  value = var.enable_static_website ? aws_s3_bucket_website_configuration.this[0].website_endpoint : null
}

output "website_domain" {
  value = var.enable_static_website ? aws_s3_bucket_website_configuration.this[0].website_domain : null
}