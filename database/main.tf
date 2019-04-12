provider "aws" {
    version = "2.5"
    region = "us-east-1"
}

resource "aws_db_instance" "mysql_db" {
    engine = "mysql"
    allocated_storage = 10
    instance_class = "db.t2.micro"
    name = "cluster_mysql_db"
    username = "admin"
    password = "${var.db_password}"
}