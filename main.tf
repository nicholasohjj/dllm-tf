provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = "terraform-bucket-dllm"  # Replace with your bucket name
    key            = "dllm-tf/terraform.tfstate"    # Set a unique path for your project
    region         = "ap-southeast-1"                    # Replace with your region
    encrypt        = true
  }
}