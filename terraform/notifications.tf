# Forward primary bucket events to Amazon EventBridge
resource "aws_s3_bucket_notification" "secure_lab" {
  bucket      = aws_s3_bucket.secure_lab.id
  eventbridge = true
}

# Forward access logging bucket events to Amazon EventBridge
resource "aws_s3_bucket_notification" "access_logs" {
  bucket      = aws_s3_bucket.access_logs.id
  eventbridge = true
}
