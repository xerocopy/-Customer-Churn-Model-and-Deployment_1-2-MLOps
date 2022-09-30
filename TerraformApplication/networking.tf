# 1. Create vpc
resource "aws_vpc" "prod-vpc" {
    cidr_block = var.cidr_block
    tags = {
        Name = "customer-churn-production"
    }
}



# 4. Create a Subnet
# resource "aws_subnet" "subnet-1" {
#   vpc_id = aws_vpc.prod-vpc.id
#   cidr_block = "10.0.1.0/24"
#   availability_zone = "us-east-1a"
  
#   tags = {
#       Name = "customer-churn-prod-subnet"
#   }
# }

# resource "aws_subnet" "subnet-2" {
#   vpc_id = aws_vpc.prod-vpc.id
#   cidr_block = "10.0.2.0/24"
#   availability_zone = "us-east-1b"
  
#   tags = {
#       Name = "customer-churn-prod-subnet"
#   }
# }

# resource "aws_subnet" "subnet-3" {
#   vpc_id = aws_vpc.prod-vpc.id
#   cidr_block = "10.0.3.0/24"
#   availability_zone = "us-east-1c"
  
#   tags = {
#       Name = "customer-churn-prod-subnet"
#   }
# }

# resource "aws_subnet" "subnet-4" {
#   vpc_id = aws_vpc.prod-vpc.id
#   cidr_block = "10.0.4.0/24"
#   availability_zone = "us-east-1d"
  
#   tags = {
#       Name = "customer-churn-prod-subnet"
#   }
# }

# resource "aws_subnet" "subnet-5" {
#   vpc_id = aws_vpc.prod-vpc.id
#   cidr_block = "10.0.5.0/24"
#   availability_zone = "us-east-1e"
  
#   tags = {
#       Name = "customer-churn-prod-subnet"
#   }
# }

# resource "aws_subnet" "subnet-6" {
#   vpc_id = aws_vpc.prod-vpc.id
#   cidr_block = "10.0.6.0/24"
#   availability_zone = "us-east-1f"
  
#   tags = {
#       Name = "customer-churn-prod-subnet"
#   }
# }


resource "aws_subnet" "private_subnet" {
  # Use the count meta-parameter to create multiple copies
  count  = 2
  vpc_id = aws_vpc.prod-vpc.id
  # cidrsubnet function splits a cidr block into subnets
  cidr_block = cidrsubnet(var.cidr_block, 2, count.index)
  # element retrieves a list element at a given index
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "customer-churn-private-subnet${count.index + 1}"
  }
}

# Internet gateway to reach the internet
resource "aws_internet_gateway" "web_igw" {
  vpc_id = aws_vpc.prod-vpc.id
}

# Route table with a route to the internet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web_igw.id
  }

  tags = {
    Name = "Public Subnet Route Table"
  }
}


# Subnets with routes to the internet
resource "aws_subnet" "public_subnet" {
  # Use the count meta-parameter to create multiple copies
  count                   = 2
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = cidrsubnet(var.cidr_block, 2, count.index + 2)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "customer-churn-private-subnet ${count.index + 1}"
  }
}

# Associate public route table with the public subnets
resource "aws_route_table_association" "public_subnet_rta" {
  count          = 2
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public_rt.id
}



# 6. Create Security Group to allow port 22,80,443
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.prod-vpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  ingress {
    description      = "HTTP"
    from_port        = 5000
    to_port          = 5000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
    egress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
}