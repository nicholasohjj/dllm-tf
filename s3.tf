resource "aws_s3_bucket" "archived-data" {
  bucket = "archived-data-dllm"
}

resource "aws_s3_bucket" "pretrained-model" {
  bucket = "pretrained-model-dllm"
}
