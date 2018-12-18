terraform {
  backend "s3" {
    bucket = "gds-frontend-tools-tfstate"
    key    = "testing.tfstate"
    region = "eu-west-2"
  }
}

provider "aws" {}
