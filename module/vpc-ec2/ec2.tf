resource "aws_instance" "ec2" {
  ami = data.aws_ami.ami.id
  instance_type = "t3.medium"
  availability_zone = "us-east-2a"
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
  # Install necessary packages
  sudo apt-get update && sudo apt-get install -y \
    gnupg software-properties-common curl unzip apt-transport-https ca-certificates

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

  # Install Docker
  sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt-get update && sudo apt-get install -y docker-ce
  sudo usermod -aG docker $USER

  # Enable and start Docker service
  sudo systemctl enable docker
  sudo systemctl start docker

  # Install Jenkins (as a container)
  sudo docker network create jenkins
  sudo docker volume create jenkins-data
  sudo docker run \
    -d \
    --name jenkins \
    --network jenkins \
    -p 8080:8080 -p 50000:50000 \
    -v jenkins-data:/var/jenkins_home \
    -v /var/run/docker.sock:/var/run/docker.sock \
    jenkins/jenkins:lts

  # Output Jenkins initial admin password
  sudo docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
EOF
}
