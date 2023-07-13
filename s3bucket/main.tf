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
    git_commit           = "fe26475d86848bf0723065b63f8119a4abeffbe0"
    git_file             = "s3bucket/main.tf"
    git_last_modified_at = "2019-04-12 20:08:44"
    git_last_modified_by = "priteshchandaliya@gmail.com"
    git_modifiers        = "priteshchandaliya"
    git_org              = "priteshchandaliya"
    git_repo             = "terraform-up-and-running"
    owner                = "pritesh"
    team                 = "Product Management"
    yor_name             = "terraform_bucket"
    yor_trace            = "8fe152de-3e2f-4c89-926f-5cc418ab095e"
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