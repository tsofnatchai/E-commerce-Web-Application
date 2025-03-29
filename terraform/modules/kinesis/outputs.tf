output "firehose_delivery_stream_arn" {
  description = "ARN of the Kinesis Firehose delivery stream"
  value       = aws_kinesis_firehose_delivery_stream.firehose.arn
}

output "stream_name" {
  description = "Kinesis Firehose stream name"
  value       = aws_kinesis_firehose_delivery_stream.firehose.name
}
