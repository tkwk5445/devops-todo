resource "aws_instance" "ec2" {
  ami = data.aws_ami.ami.id
  instance_type = "t3.medium"
  availability_zone = "ap-northeast-2a"
  iam_instance_profile = aws_iam_instance_profile.ec2-instance-profile.id
  subnet_id = aws_subnet.public-subnet[0].id
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]

  root_block_device {
    volume_size = 50
  }

  tags = {
    Name = "[EKS] Bastion-Jenkins"
  }

  user_data = <<-EOF
  #!/bin/bash
  # Update and install basic packages
  sudo apt-get update && sudo apt-get install -y \
    gnupg software-properties-common curl unzip apt-transport-https ca-certificates
  
  # Clone Github Repository
  git clone https://github.com/tkwk5445/devops_todo_terraform.git
  cd devops_todo_terraform/eks
  chmod +x setup.sh

  # Install Terraform
  wget -O- https://apt.releases.hashicorp.com/gpg | \
  gpg --dearmor | \
  sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt-get update && sudo apt-get install -y terraform

  # Install AWS CLI
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install

  # Install kubectl
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

  # Install Docker & Docker Compose & Jenkins
  sudo apt update -y && sudo apt install -y zip
  cd /home/ubuntu && sudo git clone https://github.com/tkwk5445/jenkins_Scripts.git 
  cd jenkins_Scripts/ && sudo chmod u+x *.sh
  sudo ./install-docker.sh && sudo ./install-docker-compose.sh && docker-compose up -d --build
EOF
}
