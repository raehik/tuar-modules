output "http_public_fqdn" {
  value = "${aws_elb.http_autoscaling.dns_name}"
}

output "asg_name" {
  value = "${aws_autoscaling_group.http_autoscaling.name}"
}

output "elb_security_group_id" {
  value = "${aws_security_group.elb.id}"
}
