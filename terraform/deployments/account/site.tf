terraform {
  # comment out when bootstrapping
  backend "s3" {
    bucket = "gds-frontend-tools-tfstate"
    key    = "account.tfstate"
    region = "eu-west-2"
  }
}

provider "aws" {}


resource "aws_s3_bucket" "state" {
  bucket = "gds-frontend-tools-tfstate"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
}
