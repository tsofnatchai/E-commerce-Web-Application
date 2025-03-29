variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for remote state"
  type        = string
  default     = "terraform-state-bucket-tsofnat"
}

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
  default     = "my-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "List of Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
  default     = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
  default     = ["subnet-0fedcba9876543210", "subnet-0fedcba9876543211"]
}

variable "alb_sg_cidr" {
  description = "CIDR block allowed to access the ALB"
  type        = string
  default     = "0.0.0.0/0"
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket (used in IAM policies)"
  type        = string
  default     = "arn:aws:s3:::terraform-state-bucket-tsofnat"
}

variable "ec2_role_name" {
  description = "Name for the EC2 IAM role"
  type        = string
  default     = "example-ec2-role"
}

variable "ec2_policy_name" {
  description = "Name for the IAM policy granting S3 access"
  type        = string
  default     = "example-ec2-policy"
}

variable "instance_profile_name" {
  description = "Name for the EC2 instance profile"
  type        = string
  default     = "example-instance-profile"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "my-eks-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.31"#"1.24"
}

# variable "key_name" {
#   description = "EC2 key pair name for EKS nodes"
#   type        = string
# }
variable "firehose_bucket_name" {
  description = "Name of the S3 bucket for Kinesis Firehose delivery"
  type        = string
  #default     = "my-kinesis-firehose-bucket"
  default     = "my-unique-firehose-bucket-tsofnat"
}

variable "firehose_role_name" {
  description = "Name of the IAM role for Kinesis Firehose"
  type        = string
  default     = "KinesisFirehoseRole"
}

variable "kinesis_stream_name" {
  description = "Name of the Kinesis stream"
  type        = string
  default     = "flask-app-stream"
}
variable "environment" {
  description = "Environment name (e.g. dev, prod)"
  default     = "dev"
}
#
# variable "environment" {
#   description = "Environment name (dev, prod, etc.)"
#   type        = string
#   default     = "dev"
# }
# variable "kinesis_stream_name" {
#   description = "Name for the Kinesis stream"
#   type        = string
#   default     = "order-activity-stream"
# }

variable "shard_count" {
  description = "Number of shards for the Kinesis stream"
  type        = number
  default     = 1
}

variable "kinesis_firehose_name" {
  description = "Name for the Kinesis Firehose delivery stream"
  type        = string
  default     = "order-firehose"
}

variable "firehose_bucket_arn" {
  description = "ARN of the S3 bucket for Firehose delivery"
  type        = string
  default     = "arn:aws:s3:::my-kinesis-firehose-bucket"
  # You can set this manually if not created via Terraform,
  # e.g., "arn:aws:s3:::my-kinesis-firehose-bucket"
}

variable "firehose_role_arn" {
  description = "IAM role ARN for Kinesis Firehose"
  type        = string
  default = "aws_iam_role.firehose_role.arn"
}

variable "db_identifier" {
  description = "RDS instance identifier"
  type        = string
  default     = "mysql-db"
}

variable "db_name" {
  description = "RDS database name"
  type        = string
  default     = "mydatabase"
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
  default     = "ChangeMe123!"
}

variable "allocated_storage" {
  description = "Allocated storage for RDS (in GB)"
  type        = number
  default     = 20
}

variable "elasticsearch_domain" {
  description = "Elasticsearch/OpenSearch domain name"
  type        = string
  default     = "my-es-domain"
}

variable "elasticsearch_version" {
  description = "Elasticsearch version"
  type        = string
  default     = "7.10"
}

variable "elasticsearch_instance_type" {
  description = "Instance type for Elasticsearch nodes"
  type        = string
  default     = "t3.small.elasticsearch"
  #default     = "t3.small.search"
}

variable "elasticsearch_instance_count" {
  description = "Number of Elasticsearch nodes"
  type        = number
  default     = 2
}

variable "elasticsearch_ebs_volume_size" {
  description = "EBS volume size (in GB) for Elasticsearch"
  type        = number
  default     = 10
}

variable "elasticsearch_access_policies" {
  description = "Access policies for the Elasticsearch domain (JSON string)"
  type        = string
  default     = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowPublicRead",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "es:ESHttpGet",
      "Resource": "*"
    }
  ]
}
EOF
}

# variable "s3_bucket_arn" {
#   description = "ARN of an S3 bucket for IAM use (if needed)"
#   type        = string
#   default     = "arn:aws:s3:::some-other-bucket"
# }

# variable "firehose_role_name" {
#   description = "Name of the IAM role for Kinesis Firehose"
#   type        = string
#   default     = "KinesisFirehoseRole"
# }
# variable "firehose_bucket_name" {
#   description = "Name of the S3 bucket for Kinesis Firehose delivery"
#   type        = string
#   default     = "my-kinesis-firehose-bucket"
# }