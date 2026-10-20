# Generate a unique suffix for the S3 bucket name
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Create S3 bucket
resource "aws_s3_bucket" "secure_lab" {
  bucket = "skynetai-labs-secure-${random_id.bucket_suffix.hex}"

  tags = {
    Name    = "SkynetAI-Labs-Secure-Storage"
    Purpose = "DevSecOps-Lab4"
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "secure_lab" {
  bucket = aws_s3_bucket.secure_lab.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "secure_lab" {
  bucket = aws_s3_bucket.secure_lab.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "secure_lab" {
  bucket = aws_s3_bucket.secure_lab.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Remove incomplete multipart uploads after seven days
resource "aws_s3_bucket_lifecycle_configuration" "secure_lab" {
  bucket = aws_s3_bucket.secure_lab.id

  rule {
    id     = "abort-incomplete-multipart-uploads"
    status = "Enabled"

    filter {}

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}
