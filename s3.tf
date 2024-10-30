resource "aws_s3_bucket" "archived_data" {
  bucket = "archived-data-dllm"

  # # Block public access
  # block_public_acls = true
  # ignore_public_acls = true
  # block_public_policy = true
  # restrict_public_buckets = true

  # Add tags for resource management
  tags = {
    Name        = "Archived Data Bucket"
    Environment = "DLLM"
  }
}

resource "aws_s3_bucket_logging" "archived_data_logging" {
  bucket = aws_s3_bucket.archived_data.bucket

  target_bucket = aws_s3_bucket.terraform_bucket.bucket
  target_prefix = "logs/archived_data/"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "archived_data_sse" {
  bucket = aws_s3_bucket.archived_data.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
  
}

resource "aws_s3_bucket" "pretrained_model" {
  bucket = "pretrained-model-dllm"

  # Block public access
  # block_public_acls = true
  # ignore_public_acls = true
  # block_public_policy = true
  # restrict_public_buckets = true

  # Add tags for resource management
  tags = {
    Name        = "Pretrained Model Bucket"
    Environment = "DLLM"
  }
}

resource "aws_s3_bucket_logging" "pretrained_model_logging" {
  bucket = aws_s3_bucket.pretrained_model.bucket

  target_bucket = aws_s3_bucket.terraform_bucket.bucket
  target_prefix = "logs/pretrained_model/"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "pretrained_model_sse" {
  bucket = aws_s3_bucket.pretrained_model.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
  
}

resource "aws_s3_bucket" "terraform_bucket" {
  bucket = "terraform-bucket-dllm"

  # Block public access
  # block_public_acls = true
  # ignore_public_acls = true
  # block_public_policy = true
  # restrict_public_buckets = true

  # Add tags for resource management
  tags = {
    Name        = "Terraform Bucket"
    Environment = "DLLM"
  }
}

resource "aws_s3_bucket_logging" "terraform_bucket_logging" {
  bucket = aws_s3_bucket.terraform_bucket.bucket

  target_bucket = aws_s3_bucket.terraform_bucket.bucket
  target_prefix = "logs/terraform_bucket/"
  
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_bucket_sse" {
  bucket = aws_s3_bucket.terraform_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
  
}

resource "aws_s3_bucket_versioning" "terraform_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
