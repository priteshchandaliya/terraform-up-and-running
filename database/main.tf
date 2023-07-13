provider "aws" {
  version = "2.5"
  region  = "us-east-1"
}

resource "aws_db_instance" "mysql_db" {
  engine            = "mysql"
  allocated_storage = 10
  instance_class    = "db.t2.micro"
  name              = "cluster_mysql_db"
  username          = "admin"
  password          = "${var.db_password}"
  tags = {
    git_commit           = "aa8760b39094eb474b3be84081255da1f38c383e"
    git_file             = "database/main.tf"
    git_last_modified_at = "2019-04-12 22:21:55"
    git_last_modified_by = "priteshchandaliya@gmail.com"
    git_modifiers        = "priteshchandaliya"
    git_org              = "priteshchandaliya"
    git_repo             = "terraform-up-and-running"
    owner                = "pritesh"
    team                 = "Product Management"
    yor_name             = "mysql_db"
    yor_trace            = "e7df2ee5-e322-4aa9-9476-f878dac8d064"
  }
}