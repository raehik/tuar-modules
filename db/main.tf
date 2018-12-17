resource "aws_db_instance" "web" {
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "${var.instance_class}"
  name                = "example_database"
  username            = "${var.db_username}"
  password            = "${var.db_password}"
  skip_final_snapshot = true                    # fix stupid bullshit
}
