# all AZs specific to your AWS account
data "aws_availability_zones" "all" {}

data "terraform_remote_state" "db" {
  backend = "s3"

  config {
    region = "${var.db_terraform_state_region}"
    bucket = "${var.db_terraform_state_s3_bucket}"
    key    = "${var.db_terraform_state_s3_key}"
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.sh")}"

  vars {
    internal_http_port = "${var.internal_http_port}"
    db_address         = "${data.terraform_remote_state.db.address}"
    db_port            = "${data.terraform_remote_state.db.port}"
  }
}
