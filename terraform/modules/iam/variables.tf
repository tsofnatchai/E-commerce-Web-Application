# variable "ec2_role_name" {
#   description = "The name for the IAM role to be used by EC2 instances."
#   type        = string
# }
#
# variable "ec2_policy_name" {
#   description = "The name for the IAM policy to grant EC2 S3 read access."
#   type        = string
# }
#
# variable "instance_profile_name" {
#   description = "The name for the IAM instance profile."
#   type        = string
# }
#
# variable "s3_bucket_arn" {
#   description = "The ARN of the S3 bucket that EC2 instances need to access."
#   type        = string
# }


variable "firehose_role_name" {
  description = "The name for the IAM role used by Kinesis Firehose"
  type        = string
}

variable "firehose_bucket_arn" {
  description = "ARN of the S3 bucket for Firehose delivery (used in the policy)"
  type        = string
}
