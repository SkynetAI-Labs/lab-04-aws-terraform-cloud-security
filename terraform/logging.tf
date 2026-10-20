# Dedicated bucket for S3 server access logs
resource "aws_s3_bucket" "access_logs" {
  bucket = "skynetai-labs-logs-${random_id.bucket_suffix.hex}"

  tags = {
    Name    = "SkynetAI-Labs-Access-Logs"
    Purpose = "DevSecOps-Lab4-Audit"
  }
}

# Prevent public access to audit logs
resource "aws_s3_bucket_public_access_block" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Encrypt stored access logs using S3-managed keys
resource "aws_s3_bucket_server_side_encryption_configuration" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Allow Amazon S3 to deliver access logs securely
data "aws_iam_policy_document" "access_logs" {
  statement {
    sid    = "AllowS3ServerAccessLogs"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }

    actions = ["s3:PutObject"]

    resources = [
      "${aws_s3_bucket.access_logs.arn}/access-logs/*"
    ]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.secure_lab.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

# Reference the AWS account without hardcoding its ID
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id
  policy = data.aws_iam_policy_document.access_logs.json
}

# Automatically remove access logs after 30 days
resource "aws_s3_bucket_lifecycle_configuration" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  rule {
    id     = "expire-access-logs"
    status = "Enabled"

    filter {}

    expiration {
      days = 30
    }

    noncurrent_version_expiration {
      noncurrent_days = 7
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# Enable server access logging for the primary S3 bucket
resource "aws_s3_bucket_logging" "secure_lab" {
  bucket = aws_s3_bucket.secure_lab.id

  target_bucket = aws_s3_bucket.access_logs.id
  target_prefix = "access-logs/"

  depends_on = [
    aws_s3_bucket_policy.access_logs
  ]
}

# Enable versioning for the access logging bucket
resource "aws_s3_bucket_versioning" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}
