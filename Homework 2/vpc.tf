resource "aws_vpc" "hw2_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "hw2_vpc"
  }
}

#########  Public Subnets   #########
resource "aws_subnet" "hw2-subnet-public-1" {
  vpc_id = "${aws_vpc.hw2_vpc.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "hw2-subnet-public-2" {
  vpc_id = "${aws_vpc.hw2_vpc.id}"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1b"
 }

 #########  Private Subnets   #########
resource "aws_subnet" "hw2-subnet-private-1" {
  vpc_id = "${aws_vpc.hw2_vpc.id}"
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "hw2-subnet-private-2" {
  vpc_id = "${aws_vpc.hw2_vpc.id}"
  cidr_block = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = "us-east-1b"
 }
######### PUBLIC Subnets assiosation with rotute table    ######
resource "aws_route_table_association" "public-assoc-1" {
  subnet_id      = "${aws_subnet.hw2-subnet-public-1.id}"
  route_table_id = "${aws_route_table.HW2-public-crt.id}"
}
resource "aws_route_table_association" "public-assoc-2" {
  subnet_id      = "${aws_subnet.hw2-subnet-public-2.id}"
  route_table_id = "${aws_route_table.HW2-public-crt.id}"

}
######### Private Subnets assiosation with rotute table    ######
resource "aws_route_table_association" "private-assoc-1" {
  subnet_id      = "${aws_subnet.hw2-subnet-private-1.id}"
  route_table_id = "${aws_route_table.HW2-private-crt.id}"
}
resource "aws_route_table_association" "private-assoc-2" {
  subnet_id      = "${aws_subnet.hw2-subnet-private-2.id}"
  route_table_id = "${aws_route_table.HW2-private-crt.id}"

}
#### ELB ####
resource "aws_elb" "elb" {
    name = "elb"
    subnets = ["${aws_subnet.hw2-subnet-public-1.id}", "${aws_subnet.hw2-subnet-public-2.id}"]
    security_groups = ["${aws_security_group.ssh-allowed.id}"]
    listener {
        instance_port = 80
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }
  health_check {
      healthy_threshold = 2
      unhealthy_threshold = 2
      timeout = 3
      target = "HTTP:80/"
      interval = 30
  }
#instances                   = ["${aws_instance.web-1.id}, ${aws_instance.web-2.id}"]
 #  cross_zone_load_balancing   = true
  # idle_timeout                = 400
   #connection_draining         = true
   #connection_draining_timeout = 400


}
#### ELB Attachment ###
resource "aws_elb_attachment" "elb-group" {
  elb      = "${aws_elb.elb.id}"
  instance = "${aws_instance.web-1.id}"
}
resource "aws_elb_attachment" "elb-group1" {
  elb      = "${aws_elb.elb.id}"
  instance = "${aws_instance.web-2.id}"
}