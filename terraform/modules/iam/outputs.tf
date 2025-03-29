# output "ec2_role_arn" {
#   description = "The ARN of the created EC2 IAM role."
#   value       = aws_iam_role.ec2_role.arn
# }
#
# output "instance_profile_name" {
#   description = "The name of the IAM instance profile."
#   value       = aws_iam_instance_profile.ec2_profile.name
# }

output "firehose_role_arn" {
  description = "The ARN of the Firehose IAM role"
  value       = aws_iam_role.firehose_role.arn
}
