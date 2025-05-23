# 🚀 Hello World on AWS Fargate - Fullstack Project (Terraform + GitHub Actions)

This project showcases an end-to-end deployment of a simple "Hello World" web app to AWS using ECS Fargate. It includes:

* **Infrastructure provisioning** via Terraform
* **Dockerized application** hosted on Amazon ECR
* **CI/CD automation** with GitHub Actions that rebuilds and deploys on every push to `main`

---
# AWS Well-Architected Pillars Focus

This project demonstrates adherence to the AWS Well-Architected Framework pillars:

## 1. Operational Excellence

* **Infrastructure as Code:** Using Terraform for consistent, repeatable deployments
* **CI/CD Pipeline:** Automated testing and deployment with GitHub Actions
* **Monitoring:** CloudWatch alarms for CPU, memory, and task errors
* **Health Checks:** Application health endpoints and ALB health checks

## 2. Security

* **Network Segmentation:** Public/private subnet architecture
* **Least Privilege:** IAM roles with specific permissions
* **Security Groups:** Controlled traffic flow between components
* **ECR Scanning:** Automatic vulnerability scanning on image push

## 3. Reliability

* **Multi-AZ Deployment:** ECS tasks are distributed across availability zones
* **Load Balancing:** ALB distributes traffic and routes around failures
* **Self-healing:** ECS service maintains the desired task count automatically
* **Health Monitoring:** Proactive detection of issues through health checks

## 4. Performance Efficiency

* **Serverless Containers:** Fargate eliminates the need to provision and manage servers
* **Right-sizing:** Task definitions with appropriate CPU and memory allocations
* **Scalability:** Auto-scaling capabilities based on CPU utilization

## 5. Cost Optimization

* **Pay-per-use:** Fargate charges only for resources used
* **No over-provisioning:** Resources allocated precisely to application needs
* **Managed Services:** Using AWS managed services reduces operational overhead

This architecture provides a solid foundation that can be extended to accommodate more complex applications while maintaining alignment with AWS best practices.

![image](https://github.com/user-attachments/assets/e7af94d2-aa30-4b7c-8f08-a1f156ef5a0c)

* Added SNS Notifications & CloudWatch dashboard (outside of sketch)

## 📦 Project Structure

```bash
ecs-hello-world-monorepo/
│
├── infra/                          # Terraform configuration
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── modules/                    # VPC, ECS, etc.
│
├── hello-world-app/               # Application code and CI/CD
│   ├── index.html
│   ├── Dockerfile
│   ├── task-definition.json       # ECS Task Definition (used by GitHub Actions)
│   └── .github/
│       └── workflows/
│           └── main.yml           # GitHub Actions workflow
│
└── README.md                      # You're here 🚀
```

> 💡 **Note**: In production, this monorepo would typically be split into two separate GitHub repositories:
>
> * `ecs-hello-world-infra` for Terraform code
> * `ecs-hello-world-app` for the app code and CI/CD workflow

---

## 🎯 What This Project Does

* Builds a custom VPC with public/private subnets
* Creates an Application Load Balancer (ALB)
* Provisions an ECS Cluster and Service on Fargate
* Deploys a Dockerized app from ECR to ECS
* Automates image builds and deployments using GitHub Actions

---

## 🔧 Prerequisites

* AWS Account
* AWS CLI installed and configured
* Docker installed locally
* Terraform installed
* GitHub account

---

## 🧱 Infrastructure Setup (Terraform)

```bash
cd infra/
terraform init
terraform apply
```

This will:

* Create a VPC, Subnets, IGW, NAT GW, Route Tables
* Set up ECS Cluster, ALB, IAM Roles, Security Groups
* Create an Amazon ECR Repository

### Outputs

Terraform will output:

* `alb_url`: Use this to access your deployed app

---

## 🐳 Push First Image Manually (one-time)

```bash
cd hello-world-app/
aws ecr get-login-password --region eu-west-1 | \
  docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.eu-west-1.amazonaws.com

docker build -t hello-world .
docker tag hello-world:latest <your-ecr-url>:latest
docker push <your-ecr-url>:latest
```

---

## 🔁 GitHub Actions CI/CD

### What It Does:

On every push to `main` in the `hello-world-app` folder:

* Builds Docker image
* Pushes to ECR
* Registers a new ECS Task Definition
* Run Trivy Scanner to detect vulnerabilities in code
* Updates the ECS Service to use it

### Required GitHub Secrets:

In your GitHub repo:

```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION (eu-west-1)
ECR_REPOSITORY (hello-world)
ECS_CLUSTER_NAME (hello-world-cluster)
ECS_SERVICE_NAME (hello-world-service)
CONTAINER_NAME (hello-world)
```

### Triggering a Deployment:

```bash
cd hello-world-app/
echo "<!-- updated -->" >> index.html
git add index.html
git commit -m "feat: update hello world text"
git push origin main
```

Check GitHub Actions → Your workflow should run and deploy the new image.

---

## 🧹 Teardown

To destroy everything:

```bash
cd infra/
terraform destroy
```

To redeploy:

1. `terraform apply`
2. Rebuild + Push image manually once (only first time)
3. After that, let GitHub Actions handle it

---

## ✅ Summary

| Feature                  | Supported ✅ |
| ------------------------ | ----------- |
| ECS Fargate              | ✅           |
| ALB with Target Group    | ✅           |
| Private/Public Subnets   | ✅           |
| Docker + ECR Integration | ✅           |
| GitHub Actions CI/CD     | ✅           |
| Modular Terraform        | ✅           |

---

Enjoy deploying with Terraform & GitHub Actions! 🎉

!PLEASE NOTICE - THIS IS A PRESENTATION REPO - YOU SHOULD SPLIT THE CONTENTS INTO TWO INDIVIDUAL REPOS!
