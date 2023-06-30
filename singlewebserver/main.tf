provider "aws" {
  region  = "us-east-1"
  version = "2.5.0"
}

variable "server_port" {
  description = "port on which the webserver will be listening"
  default     = 8080
}

output "public_ip" {
  value = "${aws_instance.single_webserver.public_ip}"
}

resource "aws_instance" "single_webserver" {
  ami                    = "ami-40d28157"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

  user_data = <<-EOF
                #!/bin/bash
                echo "Hello, Pritesh" > index.html
                nohup busybox httpd -f -p "${var.server_port}" &
                EOF
  tags {
    Name = "terraform_up_and_running_example_1"
  }
  tags = {
    user = "pchandaliya"
  }
}

resource "aws_security_group" "instance" {
  name = "single_webserver_instance"

  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    user = "pchandaliya"
  }
}