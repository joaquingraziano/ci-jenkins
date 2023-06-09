module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.0"
  name    = "jenkins"
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  monitoring                  = var.monitoring
  subnet_id                   = var.public_subnets
  vpc_security_group_ids      = [var.default_security_group_id]
  associate_public_ip_address = var.ec2_associate_public_ip_address
  ## aqui poner el userdata para instalar jenkins
  user_data = <<-EOF
  #!/bin/bash -ex
  sudo apt-get update
  sudo apt-get install \
  ca-certificates \
  curl \
  gnupg \
  lsb-release
  sudo mkdir -m 0755 -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo systemctl enable docker.service
  sudo systemctl enable containerd.service
  docker run -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts-jdk11
  EOF

  tags = {
    Terraform     = "true"
    "Environment" = var.ec2_environment
  }
}

output "public_ip" {
  value = module.ec2_instance.public_ip
}
