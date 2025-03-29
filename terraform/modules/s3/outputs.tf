output "firehose_bucket_arn" {
  description = "The ARN of the S3 bucket for Kinesis Firehose delivery"
  value       = aws_s3_bucket.firehose.arn
}
