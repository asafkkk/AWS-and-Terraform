####  Web Server ####
resource "aws_instance" "web-1" {
  ami                    = "ami-024582e76075564db"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.hw2-subnet-public-1.id}"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ssh-allowed.id]


tags = {
    Name = "web-1"
    Owner = "Asaf"
    
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.private_key_path)

  }

  provisioner "remote-exec" {
    inline = [
         "sudo apt update",
         "sudo apt -y install nginx",
         "sudo chmod 666 /var/www/html/index.nginx-debian.html",
         "echo Web Server 1 > /var/www/html/index.nginx-debian.html"
    ]
  }
}

resource "aws_instance" "web-2" {
  ami                    = "ami-024582e76075564db"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.hw2-subnet-public-2.id}"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ssh-allowed.id]


tags = {
    Name = "web-2"
    Owner = "Asaf"
    
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.private_key_path)

  }

  provisioner "remote-exec" {
    inline = [
         "sudo apt update",
         "sudo apt -y install nginx",
         "sudo chmod 666 /var/www/html/index.nginx-debian.html",
         "echo Web Server 2 > /var/www/html/index.nginx-debian.html"
    ]
  }
}
#### DB Server ####
resource "aws_instance" "DB-1" {
  ami                    = "ami-024582e76075564db"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.hw2-subnet-private-1.id}"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ssh-allowed.id]


tags = {
    Name = "DB-1"
    Owner = "Asaf"
    
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.private_key_path)

  }
}
  resource "aws_instance" "db-2" {
  ami                    = "ami-024582e76075564db"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.hw2-subnet-private-2.id}"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ssh-allowed.id]


tags = {
    Name = "db-2"
    Owner = "Asaf"
    
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.private_key_path)

  }
  }