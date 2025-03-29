# resource "aws_iam_role" "ec2_role" {
#   name = var.ec2_role_name
#
#   assume_role_policy = jsonencode({
#     Version   = "2012-10-17",
#     Statement = [{
#       Effect    = "Allow",
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       },
#       Action    = "sts:AssumeRole"
#     }]
#   })
# }
#
# resource "aws_iam_policy" "ec2_policy" {
#   name        = var.ec2_policy_name
#   description = "Allows EC2 instances to read from S3 buckets"
#
#   policy = jsonencode({
#     Version   = "2012-10-17",
#     Statement = [{
#       Effect   = "Allow",
#       Action   = [
#         "s3:GetObject",
#         "s3:ListBucket"
#       ],
#       Resource = [
#         var.s3_bucket_arn,
#         "${var.s3_bucket_arn}/*"
#       ]
#     }]
#   })
# }
#
# resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {
#   role       = aws_iam_role.ec2_role.name
#   policy_arn = aws_iam_policy.ec2_policy.arn
# }
#
# resource "aws_iam_instance_profile" "ec2_profile" {
#   name = var.instance_profile_name
#   role = aws_iam_role.ec2_role.name
# }


resource "aws_iam_role" "firehose_role" {
  name = var.firehose_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "firehose.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "firehose_policy" {
  name   = "${var.firehose_role_name}-policy"
  role   = aws_iam_role.firehose_role.id
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "s3:PutObject",
        "s3:ListBucket"
      ],
      Resource = [
        var.firehose_bucket_arn,
        "${var.firehose_bucket_arn}/*"
      ]
    }]
  })
}
