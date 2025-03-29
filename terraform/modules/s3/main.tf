resource "aws_s3_bucket" "firehose" {
  bucket        = var.bucket_name
  # create_bucket_configuration {
  #   location_constraint = "eu-west-1"
  # }
  tags = {
    Environment = var.environment
    Name        = var.bucket_name
  }
  force_destroy = true
}


