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
