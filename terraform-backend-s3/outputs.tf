output "s3_bucket" {
  value = "${aws_s3_bucket.terraform_backend_s3_terraform_state.bucket}"
}

output "dynamodb_table" {
  value = "${aws_dynamodb_table.terraform_backend_s3_dynamodb_table.name}"
}
