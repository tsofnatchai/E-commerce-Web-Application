module "rds_mysql" {
  source  = "terraform-aws-modules/rds/aws"

  identifier        = "mysql-db"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_encrypted = true
  multi_az          = true

  username          = var.db_username
  password          = var.db_password
  db_name           = var.db_name

  subnet_ids              = var.private_subnets
  vpc_security_group_ids  = [var.ec2_security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.default.name
  publicly_accessible     = false
  major_engine_version    = "8.0"
  family                  = "mysql8.0"
}
resource "aws_db_subnet_group" "default" {
  name       = "rds_instance-rds_sg-rds"#local.rds_sg_name
  subnet_ids = var.private_subnets#var.subnet_ids

}