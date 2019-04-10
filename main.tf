provider "aws" {
    region = "us-east-1"
    version = "2.5.0"
}

resource "aws_instance" "single_webserver" {
    ami = "ami-40d28157"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.instance.id}"]

    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, Pritesh" > index.html
                nohup busybox httpd -f -p 8080 &
                EOF
    tags {
    Name = "terraform_up_and_running_example_1"
    }
}

resource "aws_security_group" "instance" {
    name = "single_webserver_instance"

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}