output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

# output "alb_dns_name" {
#   description = "ALB DNS name"
#   value       = module.alb.alb_dns_name  # (Assuming you have an ALB module; if not, add one)
# }

output "rds_endpoint" {
  description = "RDS MySQL endpoint"
  value       = module.rds.rds_endpoint
}

output "elasticsearch_endpoint" {
  description = "Elasticsearch/OpenSearch endpoint"
  value       = module.elasticsearch.elasticsearch_endpoint
}
output "firehose_bucket_arn" {
  description = "The ARN of the Kinesis Firehose S3 bucket"
  value       = module.s3.firehose_bucket_arn
}


output "firehose_role_arn" {
  description = "ARN of the Firehose IAM role"
  value       = module.iam.firehose_role_arn
}

output "kinesis_stream_name" {
  description = "Kinesis stream name"
  value       = module.kinesis.stream_name
}