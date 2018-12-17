# Store Terraform state in S3 with versioning & locking (via DynamoDB).
# Primarily from Jessica G's blog:
# https://medium.com/@jessgreb01/how-to-terraform-locking-state-in-s3-2dc9a5665cb6

resource "aws_s3_bucket" "terraform_backend_s3_terraform_state" {
  bucket = "${var.terraform_backend_s3_bucket}"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags {
    Name = "Remote Terraform state storage bucket"
  }
}

resource "aws_dynamodb_table" "terraform_backend_s3_dynamodb_table" {
  name           = "${var.terraform_backend_s3_dynamodb_table}"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name = "Remote Terraform state locking table"
  }

  depends_on = ["aws_s3_bucket.terraform_backend_s3_terraform_state"]
}
