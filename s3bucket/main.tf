provider "aws" {
    region = "us-east-1"
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
}


resource "aws_s3_bucket" "terraform_bucket_log_bucket" {
  bucket = "terraform_bucket-log-bucket"
}

resource "aws_s3_bucket_logging" "terraform_bucket" {
  bucket = aws_s3_bucket.terraform_bucket.id

  target_bucket = aws_s3_bucket.terraform_bucket_log_bucket.id
  target_prefix = "log/"
}