variable "terraform_backend_s3_bucket" {
  description = "S3 bucket used by Terraform for storing state"
}

variable "terraform_backend_s3_dynamodb_table" {
  description = "DynamoDB table used by Terraform for locking state"
}
