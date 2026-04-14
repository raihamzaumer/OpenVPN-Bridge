#############################################
# S3 BUCKET
#############################################
resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  tags = merge(var.tags, {
    Name = var.bucket_name
  })
}

#############################################
# VERSIONING
#############################################
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

#############################################
# SERVER SIDE ENCRYPTION
#############################################
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
  }
}

#############################################
# PUBLIC ACCESS CONTROL
#############################################
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = !var.enable_static_website
  block_public_policy     = !var.enable_static_website
  ignore_public_acls      = !var.enable_static_website
  restrict_public_buckets = !var.enable_static_website
}

#############################################
# STATIC WEBSITE CONFIGURATION
#############################################
resource "aws_s3_bucket_website_configuration" "this" {
  count  = var.enable_static_website ? 1 : 0
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }
}

#############################################
# STATIC WEBSITE PUBLIC POLICY
#############################################
resource "aws_s3_bucket_policy" "this" {
  count  = var.enable_static_website ? 1 : 0
  bucket = aws_s3_bucket.this.id

  depends_on = [aws_s3_bucket_public_access_block.this]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadForWebsite"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = "${aws_s3_bucket.this.arn}/*"
      }
    ]
  })
}

#############################################
# COMPLETE FOLDER UPLOAD
#############################################
resource "aws_s3_object" "website_files" {
  for_each = var.enable_static_website && var.upload_folder_path != "" ? fileset(var.upload_folder_path, "**") : []

  bucket = aws_s3_bucket.this.id
  key    = each.value
  source = "${var.upload_folder_path}/${each.value}"
  etag   = filemd5("${var.upload_folder_path}/${each.value}")

  content_type = lookup(var.mime_types, regex("\\.[^.]+$", each.value), "application/octet-stream")
}

#############################################
# LIFECYCLE RULE
#############################################
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = var.enable_lifecycle ? 1 : 0
  bucket = aws_s3_bucket.this.id

  rule {
    id     = var.lifecycle_rule_id
    status = "Enabled"

    filter {
      prefix = var.lifecycle_prefix
    }

    expiration {
      days = var.lifecycle_expiration_days
    }

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration_days
    }
  }
}