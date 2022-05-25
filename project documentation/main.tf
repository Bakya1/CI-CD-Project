terraform {
  required_version = ">= 0.12"
}

provider "aws" {
   region     = "us-west-2"
  access_key = ""
  secret_key = ""
}

resource "aws_vpc" "jenkins_sg" {
  cidr_block           = var.var1
  enable_dns_hostnames = true
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg1"
  description = "Allow Jenkins Traffic"
 
 
  ingress {
    description      = "Allow from Personal CIDR block"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = [var.var1]
  }

  ingress {
    description      = "Allow SSH from Personal CIDR block"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.var1]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
   #ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Jenkins"
  }
}

resource "aws_instance" "web" {
  ami             ="ami-0cb4e786f15603b0d"
  instance_type   = "t2.micro"
  key_name        = var.key_name
  security_groups = ["${aws_security_group.jenkins_sg.name}"]
  
  tags = {
    Name = "Jenkins"
  }
    user_data       = <<EOC
    #!/bin/bash

    wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
    sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    sudo apt update
    sudo apt install jenkins
    sudo apt install maven -y
    sudo apt install -y docker*
    sudo apt install gnupg2 pass
    sudo systemctl daemon-reload
    sudo systemctl start jenkins
    sudo systemctl status jenkins
    sudo chmod 666 /var/run/docker.sock
    EOC
}
