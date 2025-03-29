resource "aws_kinesis_firehose_delivery_stream" "firehose" {
  name        = var.stream_name
  destination = "extended_s3"  # changed from "s3" to "extended_s3"

  extended_s3_configuration {
    role_arn           = var.firehose_role_arn
    bucket_arn         = var.firehose_bucket_arn
    buffering_interval = 300
    buffering_size     = 5
    compression_format = "UNCOMPRESSED"
  }
}
