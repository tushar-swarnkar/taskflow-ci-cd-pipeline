#!/bin/bash
set -e
exec > >(tee /var/log/user-data.log) 2>&1

echo "Updating system..."
sudo dnf -y update

echo "Installing Java 17..."
sudo dnf -y install java-17-amazon-corretto

echo "Installing Jenkins repo + key..."
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

echo "Installing Jenkins..."
sudo dnf -y install jenkins
sudo systemctl enable --now jenkins

echo "Installing Git..."
sudo dnf -y install git

echo "Installing Docker..."
sudo dnf -y install docker
sudo systemctl enable --now docker
sudo usermod -aG docker ec2-user
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

echo "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "VERIFY:"
java -version
git --version
docker --version
docker-compose --version
sudo systemctl is-active jenkins || true

echo "DONE"
