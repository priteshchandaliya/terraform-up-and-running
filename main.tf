provider "aws" {
    region = "us-east-1"
    version = "2.5.0"
}

resource "aws_instance" "single_webserver" {
    ami = "ami-40d28157"
    instance_type = "t2.micro"

    tags {
    Name = "terraform_up_and_running_example_1"
    }
}

