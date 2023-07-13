provider "aws" {
  region  = "us-east-1"
  version = "2.5.0"
}

resource "aws_launch_configuration" "cluster_conf" {
  image_id        = "ami-40d28157"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.instance.id}"]
  user_data       = "${data.template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "user_data" {
  template = "${file("user_data.sh")}"

  vars {
    server_port = "${var.server_port}"
  }
}

resource "aws_autoscaling_group" "aws_scale" {
  launch_configuration = "${aws_launch_configuration.cluster_conf.id}"
  availability_zones   = ["${data.aws_availability_zones.all.names}"]

  load_balancers    = ["${aws_elb.loadbalancer.name}"]
  health_check_type = "ELB"

  min_size = 2
  max_size = 4

  tag {
    key                 = "Name"
    value               = "terraform_autoscaling_example"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "instance" {
  name = "security_group_ec2"

  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
  tags = {
    git_commit           = "f45567d150ffdf33604da0364069f454870d6e0e"
    git_file             = "cluster/main.tf"
    git_last_modified_at = "2019-04-11 21:30:00"
    git_last_modified_by = "priteshchandaliya@gmail.com"
    git_modifiers        = "priteshchandaliya"
    git_org              = "priteshchandaliya"
    git_repo             = "terraform-up-and-running"
    owner                = "pritesh"
    team                 = "Product Management"
    yor_name             = "instance"
    yor_trace            = "004b07c8-80a2-46d4-8414-7e78744dbc4f"
  }
}

data "aws_availability_zones" "all" {}


resource "aws_elb" "loadbalancer" {
  name               = "terraform-load-balancer"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  security_groups    = ["${aws_security_group.elb_sg.id}"]

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "${var.server_port}"
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:${var.server_port}/"
  }
  tags = {
    git_commit           = "f45567d150ffdf33604da0364069f454870d6e0e"
    git_file             = "cluster/main.tf"
    git_last_modified_at = "2019-04-11 21:30:00"
    git_last_modified_by = "priteshchandaliya@gmail.com"
    git_modifiers        = "priteshchandaliya"
    git_org              = "priteshchandaliya"
    git_repo             = "terraform-up-and-running"
    owner                = "pritesh"
    team                 = "Product Management"
    yor_name             = "loadbalancer"
    yor_trace            = "9deb9e44-880b-4eff-8341-9e161302275d"
  }
}

resource "aws_security_group" "elb_sg" {
  name = "terraform_elb_security_group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    git_commit           = "f45567d150ffdf33604da0364069f454870d6e0e"
    git_file             = "cluster/main.tf"
    git_last_modified_at = "2019-04-11 21:30:00"
    git_last_modified_by = "priteshchandaliya@gmail.com"
    git_modifiers        = "priteshchandaliya"
    git_org              = "priteshchandaliya"
    git_repo             = "terraform-up-and-running"
    owner                = "pritesh"
    team                 = "Product Management"
    yor_name             = "elb_sg"
    yor_trace            = "faa0fe25-1c6f-4979-a235-ff6ea27fdf5f"
  }
}

data "terraform_remote_state" "db" {
  backend = "s3"

  config {
    bucket = "pritesh-test-terraform"
    key    = "Users/EPSHCYA/Desktop/terraform_practise/database/terraform.tfstate"
    region = "us-east-1"
  }
}