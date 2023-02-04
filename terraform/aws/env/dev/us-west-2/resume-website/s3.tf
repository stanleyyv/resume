resource "aws_s3_bucket" "terraform_state" {
  bucket = "stanley-dev-tf-state-us-west-2"

  lifecycle {
    prevent_destroy = true
  }


  tags = {
    Name        = "stanley-dev-tf-state-us-west-2"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "tfstate_version" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
} 

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "policy" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

