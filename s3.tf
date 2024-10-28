resource "aws_s3_bucket" "archived-data" {
  bucket = "archived-data-dllm"
}

resource "aws_s3_bucket" "pretrained-model" {
  bucket = "pretrained-model-dllm"
}

resource "aws_s3_bucket" "terraform-bucket" {
  bucket = "terraform-bucket-dllm"
}

resource "aws_s3_bucket_versioning" "terraform-bucket-versioning" {
  bucket = aws_s3_bucket.terraform-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}