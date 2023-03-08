#creo ec2 para probar 

resource "aws_instance" "jenserver" {
  ami             = "ami-0357d42faf6fa582f"
  instance_type   = "t2.micro"
  key_name        = "key"
  subnet_id       = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.instance_sg.name]
  tags = {
    Name = "terraform-jenserver"
  }
}
##creo subnet publica en la vpc de eks
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}
resource "aws_security_group" "instance_sg" {
  name_prefix = "instance_sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
