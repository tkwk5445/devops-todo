resource "aws_instance" "ec2" {
  ami = data.aws_ami.ami.id
  instance_type = "t3.medium"
  availability_zone = "ap-northeast-2a"
  iam_instance_profile = aws_iam_instance_profile.ec2-instance-profile.id
  subnet_id = aws_subnet.public-subnet[0].id
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]

  root_block_device {
    volume_size = 40
  }

  tags = {
    Name = "[EKS] Bastion-Jenkins"
  }

  user_data = <<-EOF
  #!/bin/bash

  # 1. 업데이트 및 필수 패키지 설치
  sudo apt update && sudo apt upgrade -y
  sudo apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release unzip

  # Install Terraform
  wget -O- https://apt.releases.hashicorp.com/gpg | \
  gpg --dearmor | \
  sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt-get update && sudo apt-get install -y terraform

  # 1. Docker 설치 및 설정
  echo "Installing Docker..."
  sudo apt update && sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io

  # 2. Docker Compose 설치
  echo "Installing Docker Compose..."
  sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose

  # 3. AWS CLI 설치
  echo "Installing AWS CLI..."
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  rm -rf awscliv2.zip aws

  # 4. Docker 그룹 생성 및 사용자 추가
  echo "Configuring Docker permissions..."
  if ! getent group docker > /dev/null; then
    sudo groupadd docker
  fi
  sudo usermod -aG docker $(whoami)
  sudo chmod 666 /var/run/docker.sock
  newgrp docker

  # 5. Jenkins 컨테이너 실행 (포트 80)
  echo "Setting up Jenkins container..."
  docker network create jenkins || true
  docker volume create jenkins_home || true
  docker run --name jenkins --restart always -d \
      --network jenkins \
      -p 80:8080 -p 50000:50000 \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v jenkins_home:/var/jenkins_home \
      -u root \
      jenkins/jenkins:lts

  # 6. Docker CLI 설치 및 권한 부여
  echo "Configuring Docker CLI inside Jenkins container..."
  docker exec -u root jenkins bash -c "
      apt update &&
      apt install -y apt-transport-https ca-certificates curl gnupg lsb-release &&
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg &&
      echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable' > /etc/apt/sources.list.d/docker.list &&
      apt update &&
      apt install -y docker-ce docker-ce-cli containerd.io
  "
  docker exec -u root jenkins bash -c "usermod -aG docker jenkins"

  echo "Setup complete! Jenkins is accessible at http://<your-server-ip>. Use 'sudo docker exec -it jenkins bash' to access the container."
  EOF
} 