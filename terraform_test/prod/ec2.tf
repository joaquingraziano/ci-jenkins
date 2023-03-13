resource "aws_instance" "jenkins" {
  ami           = "ami-005f9685cb30f234b"
  instance_type = "t2.micro"
  key_name      = "my_key_pair"

  subnet_id                   = aws_subnet.public_subnet_ec2.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  ## aqui poner el userdata para instalar jenkins
  user_data = <<-EOF
  #!/bin/bash -ex

  amazon-linux-extras install nginx1 -y
  echo "<h1>$(curl https://api.kanye.rest/?format=text)</h1>" >  /usr/share/nginx/html/index.html 
  systemctl enable nginx
  systemctl start nginx
  EOF

  tags = {
    Terraform     = "true"
    "Environment" = var.environment
  }
}

resource "aws_vpc" "prod" {
  cidr_block = "20.0.0.0/16"

  tags = {
    Name = "prod-vpc"
  }
}

resource "aws_subnet" "public_subnet_ec2" {
  vpc_id            = aws_vpc.prod.id
  cidr_block        = "20.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "public-prod-subnet"
  }
}

resource "aws_subnet" "private_subnet_ec2" {
  vpc_id            = aws_vpc.prod.id
  cidr_block        = "20.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-prod-subnet"
  }
}

resource "aws_internet_gateway" "igw_prod" {
  vpc_id = aws_vpc.prod.id

  tags = {
    Name = "prod-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.prod.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_prod.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.igw_prod.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.public_subnet_ec2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "web_sg" {
  name   = "HTTP and SSH"
  vpc_id = aws_vpc.prod.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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