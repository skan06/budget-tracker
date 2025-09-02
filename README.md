# 💰 Budget Tracker - Full DevOps CI/CD Pipeline on AWS EKS

A complete cloud-native application deployed via **CI/CD** using **Jenkins**, **Terraform**, and **Kubernetes (EKS)**.

This project demonstrates a real-world DevOps workflow from local development to production deployment on AWS.

---

## 🏗️ Project Overview

| Component | Technology |
|--------|------------|
| Frontend | Angular |
| Backend | Spring Boot (Java) |
| Database | PostgreSQL |
| Containerization | Docker |
| Orchestration | Kubernetes (Minikube → AWS EKS) |
| CI/CD | Jenkins |
| Code Quality | SonarQube |
| Infrastructure | AWS (EKS, ECR, VPC, S3, DynamoDB) |
| IaC | Terraform |
| Testing & Security | Checkov, Terrascan, Terratest |

---

## 📁 Project Structure
budget-tracker/
├── backend/ # Spring Boot backend
│ ├── src/
│ └── Dockerfile
├── frontend/ # Angular frontend
│ ├── src/
│ └── Dockerfile
├── kubernetes/ # Kubernetes manifests
│ ├── backend-deployment.yaml
│ ├── frontend-deployment.yaml
│ └── postgres-statefulset.yaml
├── terraform/ # AWS infrastructure
│ ├── main.tf
│ ├── eks.tf
│ ├── ecr.tf
│ ├── vpc.tf
│ ├── backend.tf
│ ├── variables.tf
│ └── outputs.tf
├── tests/ # Security & integration tests
│ ├── checkov/
│ ├── terrascan/
│ └── terratest/
│ └── terraform_test.go
├── Jenkinsfile # Jenkins CI/CD pipeline
├── docker-compose.yml # Local dev environment
├── .gitignore
└── README.md


---

## 🚀 Features

- ✅ **Local Development** with `docker-compose`
- ✅ **Minikube** for local Kubernetes testing
- ✅ **Jenkins CI/CD** with:
  - Build & test
  - SonarQube code quality
  - Docker build & push to ECR
  - Terraform apply
  - Kubernetes deploy
- ✅ **AWS Infrastructure** via Terraform:
  - VPC with public/private subnets
  - EKS cluster
  - ECR repositories
  - S3 + DynamoDB for Terraform state
- ✅ **Security & Compliance**:
  - `checkov` – IaC security scanning
  - `terrascan` – Policy compliance
  - `terratest` – Go-based integration testing

---

## 🛠️ Setup & Deployment

### 1. Local Development

```bash
# Build and run with Docker Compose
docker-compose up --build

Access:
Frontend: http://localhost:4200
Backend: http://localhost:8081/api/expenses

2. Minikube (Local Kubernetes)
minikube start --driver=docker
kubectl apply -f kubernetes/
minikube service frontend-service

3. Jenkins CI/CD Pipeline
Prerequisites
Jenkins with plugins:
Terraform
Docker
SonarQube
Checkov, Terrascan (CLI installed)
AWS credentials configured in Jenkins (aws-credentials)
SonarQube server running
Terraform installed and in PATH
Run Pipeline
Create new Jenkins job
Paste Jenkinsfile
Run Build Now
Pipeline Stages:

Clone Repository
Build Backend & Frontend
SonarQube Analysis
Docker Build
Push to ECR
Terraform Init, Plan, Apply
Security Scans (Checkov, Terrascan)
Terratest Integration Test
Deploy to Kubernetes
Verify Service

4. AWS Infrastructure (Terraform)
cd terraform
terraform init
terraform plan
terraform apply

Creates:

✅ VPC with 2 AZs
✅ EKS cluster
✅ ECR repositories
✅ S3 bucket for state (task-manager-terraform-state-sk06h)
✅ DynamoDB table for locking (terraform-locks)
✅ PostgreSQL StatefulSet in Kubernetes

profile
Qwen3-235B-A22B-2507
4:41 pm
Here is your complete, ready-to-use README.md file — one single copy-paste block with no breaks, no missing parts, and perfect formatting.

✅ Just copy everything below and paste it into a file named README.md in your project root.

markdown


1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
⌄
⌄
⌄
# 💰 Budget Tracker - Full DevOps CI/CD Pipeline on AWS EKS

A complete cloud-native application deployed via **CI/CD** using **Jenkins**, **Terraform**, and **Kubernetes (EKS)**.

This project demonstrates a real-world DevOps workflow from local development to production deployment on AWS.

---

## 🏗️ Project Overview

| Component | Technology |
|--------|------------|
| Frontend | Angular |
| Backend | Spring Boot (Java) |
| Database | PostgreSQL |
| Containerization | Docker |
| Orchestration | Kubernetes (Minikube → AWS EKS) |
| CI/CD | Jenkins |
| Code Quality | SonarQube |
| Infrastructure | AWS (EKS, ECR, VPC, S3, DynamoDB) |
| IaC | Terraform |
| Testing & Security | Checkov, Terrascan, Terratest |

---

## 📁 Project Structure

budget-tracker/
├── backend/ # Spring Boot backend
│ ├── src/
│ └── Dockerfile
├── frontend/ # Angular frontend
│ ├── src/
│ └── Dockerfile
├── kubernetes/ # Kubernetes manifests
│ ├── backend-deployment.yaml
│ ├── frontend-deployment.yaml
│ └── postgres-statefulset.yaml
├── terraform/ # AWS infrastructure
│ ├── main.tf
│ ├── eks.tf
│ ├── ecr.tf
│ ├── vpc.tf
│ ├── backend.tf
│ ├── variables.tf
│ └── outputs.tf
├── tests/ # Security & integration tests
│ ├── checkov/
│ ├── terrascan/
│ └── terratest/
│ └── terraform_test.go
├── Jenkinsfile # Jenkins CI/CD pipeline
├── docker-compose.yml # Local dev environment
├── .gitignore
└── README.md



1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32

---

## 🚀 Features

- ✅ **Local Development** with `docker-compose`
- ✅ **Minikube** for local Kubernetes testing
- ✅ **Jenkins CI/CD** with:
  - Build & test
  - SonarQube code quality
  - Docker build & push to ECR
  - Terraform apply
  - Kubernetes deploy
- ✅ **AWS Infrastructure** via Terraform:
  - VPC with public/private subnets
  - EKS cluster
  - ECR repositories
  - S3 + DynamoDB for Terraform state
- ✅ **Security & Compliance**:
  - `checkov` – IaC security scanning
  - `terrascan` – Policy compliance
  - `terratest` – Go-based integration testing

---

## 🛠️ Setup & Deployment

### 1. Local Development

```bash
# Build and run with Docker Compose
docker-compose up --build
Access:

Frontend: http://localhost:4200
Backend: http://localhost:8081/api/expenses
2. Minikube (Local Kubernetes)
bash


1
2
3
minikube start --driver=docker
kubectl apply -f kubernetes/
minikube service frontend-service
3. Jenkins CI/CD Pipeline
Prerequisites
Jenkins with plugins:
Terraform
Docker
SonarQube
Checkov, Terrascan (CLI installed)
AWS credentials configured in Jenkins (aws-credentials)
SonarQube server running
Terraform installed and in PATH
Run Pipeline
Create new Jenkins job
Paste Jenkinsfile
Run Build Now
Pipeline Stages:

Clone Repository
Build Backend & Frontend
SonarQube Analysis
Docker Build
Push to ECR
Terraform Init, Plan, Apply
Security Scans (Checkov, Terrascan)
Terratest Integration Test
Deploy to Kubernetes
Verify Service
4. AWS Infrastructure (Terraform)
bash


1
2
3
4
cd terraform
terraform init
terraform plan
terraform apply
Creates:

✅ VPC with 2 AZs
✅ EKS cluster
✅ ECR repositories
✅ S3 bucket for state (task-manager-terraform-state-sk06h)
✅ DynamoDB table for locking (terraform-locks)
✅ PostgreSQL StatefulSet in Kubernetes

5. Access the App
After deployment, get the frontend URL:
kubectl get service frontend-service

🔐 Security & Testing

1/ Checkov (IaC Security):
checkov -d terraform/

Scans for:
Open security groups
Missing encryption
Hardcoded secrets

2/ Terrascan (Policy Compliance):
terrascan scan -d terraform/

Enforces:
Tagging policies
Naming conventions
Best practices

3/Terratest (Integration Testing):
cd tests/terratest
go test -v

Verifies:
EKS cluster creation
Outputs match expected values
App URL is accessible

🎯 Learning Outcomes

How to build a full-stack app with Angular + Spring Boot
Dockerize applications
Use docker-compose for local dev
Deploy to Kubernetes (Minikube)
Automate CI/CD with Jenkins
Integrate SonarQube for code quality
Provision AWS infrastructure with Terraform
Store Terraform state in S3 + DynamoDB
Secure IaC with Checkov & Terrascan
Test infrastructure with Terratest

📌 Notes

🔐 Never commit .tfstate, .env, or secrets
🔄 Always run terraform plan before apply
🧼 Clean up with terraform destroy when done
🔄 Update terraform.tfvars with your AWS account ID

🙌 Author

Skander Houidi / DevOps Engineer
GitHub: @skan06