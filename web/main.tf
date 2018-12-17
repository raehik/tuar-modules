resource "aws_launch_configuration" "http_autoscaling" {
  image_id        = "ami-0bdf93799014acdc4"
  instance_type   = "${var.instance_type}"
  security_groups = ["${aws_security_group.autoscaler.id}"]
  user_data       = "${data.template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "http_autoscaling" {
  launch_configuration = "${aws_launch_configuration.http_autoscaling.id}"
  availability_zones   = ["${data.aws_availability_zones.all.names}"]

  load_balancers    = ["${aws_elb.http_autoscaling.id}"]
  health_check_type = "ELB"

  min_size = "${var.http_autoscaling_min}"
  max_size = "${var.http_autoscaling_max}"

  tag {
    key                 = "Name"
    value               = "${var.module_root}"
    propagate_at_launch = true
  }
}

resource "aws_elb" "http_autoscaling" {
  name               = "${replace(var.module_root, "/\\./", "-")}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  security_groups    = ["${aws_security_group.elb.id}"]

  listener {
    lb_port           = "${var.http_port}"
    lb_protocol       = "http"
    instance_port     = "${var.internal_http_port}"
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:${var.internal_http_port}/"
  }
}

resource "aws_security_group" "elb" {
  name = "${var.module_root}-elb"
}

resource "aws_security_group" "autoscaler" {
  name = "${var.module_root}-autoscaler"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.elb.id}"

  from_port   = "${var.http_port}"
  to_port     = "${var.http_port}"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_out_outbound" {
  type              = "egress"
  security_group_id = "${aws_security_group.elb.id}"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_internal_http_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.autoscaler.id}"

  from_port   = "${var.internal_http_port}"
  to_port     = "${var.internal_http_port}"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
