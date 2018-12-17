variable "instance_type" {
  description = "AWS EC2 Instance type to use (e.g. t2.micro)"
}

variable "http_autoscaling_min" {
  description = "minimum instances for the HTTP server autoscaling group"
}

variable "http_autoscaling_max" {
  description = "maximum instances for the HTTP server autoscaling group"
}

variable "http_port" {
  description = "port to handle HTTP requests"
}

variable "db_terraform_state_region" {
  description = "AWS region for Terraform-managed database's Terraform state"
}

variable "db_terraform_state_s3_bucket" {
  description = "S3 bucket for Terraform-managed database's Terraform state"
}

variable "db_terraform_state_s3_key" {
  description = "S3 key for Terraform-managed database's Terraform state"
}
