provider "aws" {
  region = var.region
}

data "aws_s3_bucket" "s3" {
  bucket = var.s3_bucket_name
}

module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr   = var.vpc_cidr
  region   = var.region
}

module "security" {
  source      = "./modules/security"
  vpc_id      = module.vpc.vpc_id
  alb_sg_cidr = var.alb_sg_cidr
}

# module "iam" {
#   source                = "./modules/iam"
#   ec2_role_name         = var.ec2_role_name
#   ec2_policy_name       = var.ec2_policy_name
#   instance_profile_name = var.instance_profile_name
#   s3_bucket_arn         = var.s3_bucket_arn
# }
module "s3" {
  source      = "./modules/s3"
  bucket_name = var.firehose_bucket_name
  environment = var.environment
  #kinesis_firehose_bucket_arn = ""
  #kinesis_firehose_role_arn = ""
}
module "iam" {
  source              = "./modules/iam"
  firehose_role_name  = var.firehose_role_name
  firehose_bucket_arn = module.s3.firehose_bucket_arn
}

module "eks" {
  source         = "./modules/eks"
  cluster_name   = var.cluster_name
  cluster_version= var.cluster_version
  vpc_id         = module.vpc.vpc_id
  #public_subnets = module.vpc.public_subnets
  private_subnets= module.vpc.private_subnets
}

# module "kinesis" {
#   source              = "./modules/kinesis"
#   kinesis_firehose_bucket_arn = module.s3.firehose_bucket_arn
#   kinesis_firehose_role_arn   = module.iam.firehose_role_arn
#   #firehose_role_name          = var.firehose_role_name
#
#   #firehose_bucket_name = module.s3.firehose_bucket_arn  # Your bucket name
#   #firehose_role_name   = "KinesisFirehoseRole"          # Your Firehose role name
#   stream_name         = var.kinesis_stream_name
#   shard_count         = var.shard_count
#   firehose_name       = var.kinesis_firehose_name
#   firehose_bucket_arn = var.kinesis_firehose_bucket_arn
#   firehose_role_arn   = var.kinesis_firehose_role_arn
# }
module "kinesis" {
  source = "./modules/kinesis"
  firehose_bucket_arn = module.s3.firehose_bucket_arn
  firehose_role_arn   = module.iam.firehose_role_arn
  stream_name = var.kinesis_stream_name
}
module "rds" {
  source               = "./modules/rds"
  vpc_id               = module.vpc.vpc_id
  private_subnets      = module.vpc.private_subnets
  ec2_security_group_id= module.security.rds_security_group_id
  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
}

# module "rds" {
#   source                 = "./modules/rds"
#   vpc_id                 = module.vpc.vpc_id
#   private_subnet_ids     = module.vpc.private_subnets
#   vpc_security_group_ids = [module.security.rds_security_group_id]
#   db_identifier          = var.db_identifier
#   db_name                = var.db_name
#   db_username            = var.db_username
#   db_password            = var.db_password
#   allocated_storage      = var.allocated_storage
# }
# Get current AWS account ID dynamically
data "aws_caller_identity" "current" {}

module "elasticsearch" {
  source             = "./modules/elasticsearch"
  domain_name        = var.elasticsearch_domain
  elasticsearch_version = var.elasticsearch_version
  instance_type      = var.elasticsearch_instance_type
  instance_count     = var.elasticsearch_instance_count
  ebs_volume_size    = var.elasticsearch_ebs_volume_size
  subnet_ids         = module.vpc.private_subnets
  security_group_ids = module.security.ec2_security_group_ids
  access_policies    = var.elasticsearch_access_policies
  region             = var.region
}

