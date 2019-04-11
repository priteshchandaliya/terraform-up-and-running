provider "aws" {
    region = "us-east-1"
    version = "2.5.0"
}

variable "server_port" {
    description = "port on which the webserver will be listening"
    default = 8080
}

output "elb_dns_name" {
    value = "${aws_elb.loadbalancer.dns_name}"
}

resource "aws_launch_configuration" "cluster_conf" {
    image_id = "ami-40d28157"
    instance_type = "t2.micro"
    security_groups = ["${aws_security_group.instance.id}"]

    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, Pritesh" > index.html
                nohup busybox httpd -f -p "${var.server_port}" &
                EOF
    
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "aws_scale" {
    launch_configuration = "${aws_launch_configuration.cluster_conf.id}"
    availability_zones = ["${data.aws_availability_zones.all.names}"]

    load_balancers = ["${aws_elb.loadbalancer.name}"]
    health_check_type = "ELB"

    min_size = 2
    max_size = 4

    tag {
        key = "Name"
        value = "terraform_autoscaling_example"
        propagate_at_launch = true
    }
}

resource "aws_security_group" "instance" {
    name = "security_group_ec2"
    
    ingress {
        from_port = "${var.server_port}"
        to_port = "${var.server_port}"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    lifecycle {
        create_before_destroy = true
    }  
}

data "aws_availability_zones" "all" {}


resource "aws_elb" "loadbalancer" {
    name = "terraform-load-balancer"
    availability_zones = ["${data.aws_availability_zones.all.names}"]
    security_groups = ["${aws_security_group.elb_sg.id}"]

    listener {
        lb_port = 80
        lb_protocol = "http"
        instance_port = "${var.server_port}"
        instance_protocol = "http"
    }

    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        interval = 30
        target = "HTTP:${var.server_port}/"
    }
}

resource "aws_security_group" "elb_sg" {
    name = "terraform_elb_security_group"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}