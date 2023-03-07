#creo ec2 para probar 

resource "aws_instance" "example" {
	ami = "ami-0357d42faf6fa582f"
	instance_type = "t2.micro"
}