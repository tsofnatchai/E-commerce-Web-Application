output "elasticsearch_endpoint" {
  description = "Elasticsearch domain endpoint"
  value       = aws_elasticsearch_domain.this.endpoint
}
