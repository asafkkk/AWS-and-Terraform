### Add Internet Gateway ###
resource "aws_internet_gateway" "hw2-igw" {
    vpc_id = "${aws_vpc.hw2_vpc.id}"
    
    }
### Route Tables ###
resource "aws_route_table" "HW2-public-crt" {
    vpc_id = "${aws_vpc.hw2_vpc.id}"
    tags = {
        Name = "HW2-public-crt"
    }    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        //CRT uses this IGW to reach internet
        gateway_id = "${aws_internet_gateway.hw2-igw.id}" 
    }

    
    
}

  resource "aws_route_table" "HW2-private-crt" {
    vpc_id = "${aws_vpc.hw2_vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_nat_gateway.main-natgw.id}"
    }
    tags = {
        Name = "HW2-private-crt"
    }
  }
   #####NAT#######     
resource "aws_eip" "nat" {
}

resource "aws_nat_gateway" "main-natgw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.hw2-subnet-public-1.id}"

  
  
}
    ### Security Group ###
    resource "aws_security_group" "ssh-allowed" {
    vpc_id = "${aws_vpc.hw2_vpc.id}"
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        // This means, all ip address are allowed to ssh ! 
        // Do not do it in the production. 
        // Put your office or home address in it!
        cidr_blocks = ["0.0.0.0/0"]
    }
    //If you do not add this rule, you can not reach the NGIX  
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
}