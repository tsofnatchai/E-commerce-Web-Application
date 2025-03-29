terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-tsofnat"
    key            = "prod/terraform.tfstate"  # Path inside the bucket
    region         = "us-east-1"
    encrypt        = true                      # Encrypt the state file
    dynamodb_table = "terraform-locking-user-tsofnat"       # For state locking
  }
}