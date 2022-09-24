# 1. Create vpc
resource "aws_vpc" "prod-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "customer-churn-production"
    }
}

# 2. Create Internet Gateway
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.prod-vpc.id
    
}


resource "aws_egress_only_internet_gateway" "egw" {
  vpc_id = aws_vpc.prod-vpc.id
}



# 4. Create a Subnet
resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.prod-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  
  tags = {
      Name = "customer-churn-prod-subnet"
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id = aws_vpc.prod-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  
  tags = {
      Name = "customer-churn-prod-subnet"
  }
}

resource "aws_subnet" "subnet-3" {
  vpc_id = aws_vpc.prod-vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1c"
  
  tags = {
      Name = "customer-churn-prod-subnet"
  }
}

resource "aws_subnet" "subnet-4" {
  vpc_id = aws_vpc.prod-vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1d"
  
  tags = {
      Name = "customer-churn-prod-subnet"
  }
}

resource "aws_subnet" "subnet-5" {
  vpc_id = aws_vpc.prod-vpc.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "us-east-1e"
  
  tags = {
      Name = "customer-churn-prod-subnet"
  }
}

resource "aws_subnet" "subnet-6" {
  vpc_id = aws_vpc.prod-vpc.id
  cidr_block = "10.0.6.0/24"
  availability_zone = "us-east-1f"
  
  tags = {
      Name = "customer-churn-prod-subnet"
  }
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
    description      = "SSH"
    from_port        = 2
    to_port          = 2
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}