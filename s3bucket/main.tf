provider "aws" {
  region  = "us-east-1"
  version = "2.5"
}

resource "aws_s3_bucket" "terraform_bucket" {
  bucket = "${var.bucket_name}"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
  tags = {
    user = "pchandaliya"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_bucket" {
  bucket = aws_s3_bucket.terraform_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}