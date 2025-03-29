variable "domain_name" {
  description = "Elasticsearch domain name"
  type        = string
}

variable "elasticsearch_version" {
  description = "Elasticsearch version"
  type        = string
  default     = "7.10"  // or "OpenSearch_1.0", etc.
}

variable "instance_type" {
  description = "Instance type for Elasticsearch nodes"
  type        = string
}

variable "instance_count" {
  description = "Number of Elasticsearch nodes"
  type        = number
}

variable "ebs_volume_size" {
  description = "EBS volume size (in GB) for Elasticsearch"
  type        = number
}

variable "subnet_ids" {
  description = "Subnets for the Elasticsearch domain (private subnets)"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs for Elasticsearch"
  type        = list(string)
}

variable "access_policies" {
  description = "Access policies for the Elasticsearch domain (JSON string)"
  type        = string
}
variable "region" {
  description = "AWS region for Elasticsearch"
  type        = string
}