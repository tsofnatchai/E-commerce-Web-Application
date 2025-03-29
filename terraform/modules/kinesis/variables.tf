variable "stream_name" {
  description = "Name of the Kinesis Firehose delivery stream"
  type        = string
}

variable "firehose_bucket_arn" {
  description = "ARN of the S3 bucket for Kinesis Firehose delivery"
  type        = string
}

variable "firehose_role_arn" {
  description = "ARN of the IAM role for Kinesis Firehose"
  type        = string
}
