output "address" {
  value = "${aws_db_instance.web.address}"
}

output "port" {
  value = "${aws_db_instance.web.port}"
}
