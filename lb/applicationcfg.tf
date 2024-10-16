terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }


}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  s3_force_path_style         = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  endpoint                    = "http://localhost:4566"
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = "my-application-bucket"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_object" "index" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "index.html"
  acl    = "public-read"
}

resource "aws_s3_bucket_object" "error" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "error.html"
  source = "error.html"
  acl    = "public-read"
}
