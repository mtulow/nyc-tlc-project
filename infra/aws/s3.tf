# Data Lake: S3 Bucket
resource "aws_s3_bucket" "dl" {
  bucket_prefix = "${var.project_name}-"
  tags = {
    Name          = var.project_name
    Environment   = var.app_env
  }
}