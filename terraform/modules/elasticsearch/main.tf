data "aws_caller_identity" "current" {}

resource "aws_elasticsearch_domain" "this" {
  domain_name           = var.domain_name
  elasticsearch_version = var.elasticsearch_version

  cluster_config {
    instance_type  = var.instance_type
    instance_count = var.instance_count
    dedicated_master_enabled = false
    zone_awareness_enabled   = true
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.ebs_volume_size
    volume_type = "gp2"
  }

  vpc_options {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  #access_policies = var.access_policies
  access_policies = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Sid: "AllowAll",
        Effect: "Allow",
        Principal: "*",
        Action: "es:*",
        Resource: "arn:aws:es:${var.region}:${data.aws_caller_identity.current.account_id}:domain/${var.domain_name}/*"
      }
    ]
  })

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }
}


