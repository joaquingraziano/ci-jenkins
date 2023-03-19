module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.0"
  name    = "jenkins"
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  monitoring                  = var.monitoring
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  
  /*
  vpc_security_group_ids      = [module.public_bastion_sg.this_security_group_id]*/
  associate_public_ip_address = var.ec2_associate_public_ip_address
  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 30
    }
  ]
  ## aqui poner el userdata para instalar jenkins
  user_data = <<EOF
  #!/bin/bash
  sudo apt update -y
  sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
  apt-cache policy docker-ce
  sudo apt install docker-ce -y
  sudo systemctl enable docker
  sudo systemctl start docker
  sudo usermod -aG docker ubuntu
  sudo docker run -d -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts-jdk11
  EOF
  /*
  access docker container logs for jenkins
  sudo docker ps
  sudo docker logs -f <container id>
  */
  tags = {
    "Terraform"     = "true"
    "Environment" = var.ec2_environment
  }
}