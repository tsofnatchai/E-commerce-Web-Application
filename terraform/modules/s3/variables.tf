variable "bucket_name" {
  description = "Name of the S3 bucket for Kinesis Firehose delivery"
  type        = string
}

variable "environment" {
  description = "Environment tag for the bucket"
  type        = string
  default     = "dev"
}
