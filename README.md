# 🚀 TaskFlow CI/CD Pipeline

A simple end-to-end DevOps project demonstrating CI/CD pipeline implementation for a Spring Boot application using Docker, Jenkins, and AWS EC2 provisioned via Terraform.

---

## ⚡ What This Project Demonstrates

- CI/CD pipeline implementation using Jenkins (Pipeline as Code)
- Docker-based containerization
- Automated deployment to EC2 via SSH
- Infrastructure provisioning using Terraform (VPC, Subnet, EC2, Security Groups)
- Secure credential handling in Jenkins (Docker Hub + SSH keys)
---

## 🧱 Tech Stack

- **Backend**: Java, Spring Boot  
- **Build Tool**: Maven  
- **Containerization**: Docker  
- **CI/CD**: Jenkins (Pipeline as Code)  
- **Cloud**: AWS EC2  
- **Infrastructure**: Terraform  
- **Version Control**: Git, GitHub  

---

## ⚙️ Project Structure
```
task-flow-project/
│
├── src/                # Spring Boot application
├── pom.xml
├── Dockerfile
│
├── infra/              # Terraform configuration
│ ├── main.tf
│ ├── provider.tf
│ ├── variables.tf
│ ├── output.tf
│ └── installations.sh  # shell script
│
├── Jenkinsfile         # CI/CD pipeline definition
└── README.md
```
---

## 🔄 CI/CD Pipeline Flow

The Jenkins pipeline automates the following steps:

1. **Checkout Code** from GitHub repository  
2. **Build Docker Image** for the Spring Boot application  
3. **Push Image to Docker Hub**  
4. **Deploy to EC2 Instance** using SSH  
5. **Run Container** with updated image  
6. **Health Check** via API endpoint  

---

## 🧾 Shell Automation

- Wrote Bash scripts to:
  - Install Jenkins and required dependencies  
  - Install and configure Docker & Docker Compose  
  - Install Git and verify setup  
- Used these scripts during EC2 provisioning to avoid manual server setup

---

## 🐳 Docker Setup

- Multi-stage Docker build used for optimized image size  
- Maven used in build stage to package the application  
- Lightweight runtime image used for execution  

---

## ☁️ Cloud Infrastructure (Terraform)

- Created custom VPC, Subnet, Route Table  
- Configured Internet Gateway for public access  
- Defined Security Groups (ports 22, 8080, 9000)  
- Provisioned EC2 instance  
- Automated setup using `user_data` scripts  

---

## 🔧 Jenkins Setup

- Installed Jenkins on EC2  
- Configured:
  - Docker
  - Git
  - Java
- Created pipeline using `Jenkinsfile`  
- Integrated GitHub webhook for automatic triggers  

---

## 🔐 Security & Access

- SSH-based deployment using private key authentication  
- Jenkins credentials used to securely store:
  - Docker Hub credentials  
  - EC2 SSH key  

---

## 📡 API Endpoints

- `GET /api/health` → Health check  
- `GET /api/version` → Returns deployed version   

---

## 🙌 Author

**Tushar Swarnkar**  
Aspiring Backend & DevOps Engineer  

---


