##################################################################################
# VARIABLES
##################################################################################

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}
variable "key_name" {}
variable "region" {
  default = "us-east-1"
}

##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

##################################################################################
# RESOURCES
##################################################################################

#This uses the default VPC.  It WILL NOT delete it on destroy.
resource "aws_default_vpc" "default" {

}
resource "aws_security_group" "allow_ssh" {
  name        = "homework1"
  description = "Allow ports for nginx"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nginx" {
  count = 2
  ami                    = "ami-024582e76075564db"
  instance_type          = "t2.medium"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]


tags = {
    Name = "Nginx-${count.index + 1}"
    Owner = "Asaf"
    Purpose = "learning"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.private_key_path)

  }

ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = 10
    volume_type = "gp2"
    encrypted = "true"
    
  }

  provisioner "remote-exec" {
    inline = [
         "sudo apt update",
         "sudo apt -y install nginx",
         "sudo chmod 666 /var/www/html/index.nginx-debian.html",
         "echo opschool rules > /var/www/html/index.nginx-debian.html"
    ]
  }
}
