# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_elb" "web" {
  name = "terraform-example-elb"

  availability_zones = ["${aws_instance.web.*.availability_zone}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  # The instances are registered automatically
  instances = ["${aws_instance.web.*.id}"]
}

resource "aws_instance" "web" {
  instance_type = "t1.small"
  ami           = "${lookup(var.aws_amis, var.aws_region)}"

  count = 6
}
