#main.tf
#defining the provider as aws
provider "aws" {
    region     = "${var.region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    token      = "${var.session_token}"
}

#create a security group for RDS Database Instance
resource "aws_security_group" "rds_sg" {
  name = "rds_sg"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#create a RDS Database Instance
resource "aws_db_instance" "myinstance" {
  engine               = "mysql"
  identifier           = "myrdsinstance"
  allocated_storage    =  20
  engine_version       = "8.0.35"
  instance_class       = "db.t3.micro"
  username             = "usradmin"
  password             = "S3nhaSup34S3gura"
  parameter_group_name = "default.mysql8.0"
  vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
  skip_final_snapshot  = true
  publicly_accessible =  true
}