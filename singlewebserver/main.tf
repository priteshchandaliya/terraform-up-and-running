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
    git_commit           = "f45567d150ffdf33604da0364069f454870d6e0e"
    git_file             = "singlewebserver/main.tf"
    git_last_modified_at = "2019-04-11 21:30:00"
    git_last_modified_by = "priteshchandaliya@gmail.com"
    git_modifiers        = "priteshchandaliya"
    git_org              = "priteshchandaliya"
    git_repo             = "terraform-up-and-running"
    owner                = "pritesh"
    team                 = "Product Management"
    yor_name             = "single_webserver"
    yor_trace            = "6079862d-38c6-4080-a3be-3b5e058dddd0"
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
    git_commit           = "f45567d150ffdf33604da0364069f454870d6e0e"
    git_file             = "singlewebserver/main.tf"
    git_last_modified_at = "2019-04-11 21:30:00"
    git_last_modified_by = "priteshchandaliya@gmail.com"
    git_modifiers        = "priteshchandaliya"
    git_org              = "priteshchandaliya"
    git_repo             = "terraform-up-and-running"
    owner                = "pritesh"
    team                 = "Product Management"
    yor_name             = "instance"
    yor_trace            = "69fc10c2-7db3-48f6-a2b2-e608f049d508"
  }
}