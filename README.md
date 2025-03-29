# E-commerce Web Application on AWS

This project is an end-to-end e-commerce web application built with Flask, deployed on Kubernetes (EKS) with Helm, and provisioned entirely with Terraform. It integrates several AWS services to deliver a scalable, secure, and real-time data processing solution.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Infrastructure Provisioning with Terraform](#infrastructure-provisioning-with-terraform)
- [Building and Deploying the Flask Application](#building-and-deploying-the-flask-application)
- [Helm Deployment](#helm-deployment)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Overview

This project delivers an e-commerce web application with the following features:

1. **Flask Web Application:**
   - User authentication
   - Product catalog management
   - Real-time order tracking
   - Integration with AWS Kinesis Streams to capture user activity and order data
   - Elasticsearch integration for full-text search across the product catalog

2. **Kubernetes (EKS) Deployment with Helm:**
   - The Flask application is containerized and deployed on AWS EKS using Helm charts.
   - Horizontal Pod Autoscaler (HPA) scales the application pods based on CPU/memory.
   - Vertical Pod Autoscaler (VPA) dynamically adjusts resource limits.
   - Persistent storage via EBS volumes for stateful data.

3. **Infrastructure as Code (Terraform):**
   - Provisioning of all AWS resources (VPC, EKS cluster, RDS, S3 buckets, DynamoDB, Elasticsearch, IAM roles, etc.) using Terraform modules.
   - IAM Roles for Service Accounts (IRSA) to control pod access securely.

4. **Real-time Data Processing (AWS Kinesis):**
   - Kinesis Streams capture real-time events (e.g., order creation).
   - Kinesis Data Firehose delivers data to S3 (and optionally forwards data to Elasticsearch for analytics).

5. **Kubernetes Security & Networking:**
   - RBAC and Network Policies secure inter-pod communication.
   - TLS/SSL termination via AWS ACM (configured via Ingress).

## Architecture

![Untitled diagram-2025-03-29-091145](https://github.com/user-attachments/assets/5dec062e-1d2a-4e17-a20a-1b34bc7b1add)


## Prerequisites

- **AWS Account:** Ensure you have an AWS account with permissions to create resources.
- **Terraform:** Installed (v1.x recommended).
- **Helm:** Installed (v3.x recommended).
- **kubectl:** Installed and configured to interact with your EKS cluster.
- **Docker:** Installed and configured to build and push images.
- **created S3 bucket in AWS:**
   ```bash
  aws s3api create-bucket --bucket terraform-state-bucket-tsofnat --region us-east-1
- **DynamoDB Table for State Locking:**  
  Create using:
  ```bash
  aws dynamodb create-table --table-name terraform-locking-user-tsofnat --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1

  ## Infrastructure Provisioning with Terraform

This project uses Terraform to provision all required AWS resources:
- **VPC and Networking:** VPC, public and private subnets, NAT Gateway, and security groups.
- **EKS Cluster:** Provisioned using a Terraform module (or community module) for container orchestration.
- **RDS MySQL:** A managed relational database for persistent e-commerce data.
- **S3 for Kinesis Firehose:** An S3 bucket dedicated for receiving data from Kinesis Firehose.
- **IAM Roles:** Separate IAM roles are defined for service accounts (IRSA) and for Kinesis Firehose.
- **Kinesis Streams & Firehose:** Capture real-time events (such as order creation) and deliver them to S3.
- **Elasticsearch Domain:** Provisioned for full-text search across the product catalog (using `data "aws_caller_identity" "current"` to dynamically insert account details).


## Building and Deploying the Flask Application
terraform init
terraform plan
terraform apply
This will create your VPC, EKS cluster, RDS, S3 bucket for Firehose, IAM roles, Kinesis stream & Firehose delivery stream, security groups, etc.
got:
Outputs:

eks_cluster_endpoint = "https://54ED0C364E26D6C5AF8DEA8966D1C9A7.gr7.us-east-1.eks.amazonaws.com"
elasticsearch_endpoint = "vpc-my-es-domain-4da35gonlrfy7lkbndwz2h6l3a.us-east-1.es.amazonaws.com"
firehose_bucket_arn = "arn:aws:s3:::my-unique-firehose-bucket-tsofnat"
firehose_role_arn = "arn:aws:iam::741448960679:role/KinesisFirehoseRole"
kinesis_stream_name = "flask-app-stream"
rds_endpoint = "mysql-db.curs4g4yygzv.us-east-1.rds.amazonaws.com:3306"


Build and Push Your Flask App Image:
In the flask-app/ there is a Dockerfile that installs dependencies and runs the app. Then build and push:

in bash

docker build -t tsofnatg/flask-app:latest .
docker push tsofnatg/flask-app:latest
Deploy the Flask App Using Helm on EKS:
Adjust the values in helm/flask-app/values.yaml as needed (for image repository, replica count, autoscaling settings, etc.). Then install the chart:

bash:
cd PycharmProjects/E-commerce-Web-Application/helm
helm create flask-app
cd PycharmProjects/E-commerce-Web-Application/helm/flask-app
helm install my-new-release .

got:
NAME: my-new-release
LAST DEPLOYED: Wed Mar 26 17:15:19 2025
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
1. Get the application URL by running these commands:
   export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=flask-app,app.kubernetes.io/instance=my-new-release" -o jsonpath="{.items[0].metadata.name}")
   export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
   echo "Visit http://127.0.0.1:8080 to use your application"
   kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT


export POD_NAME=$(kubectl get pods --namespace default -l "app=flask-app" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace default port-forward $POD_NAME 9090:5000

http://127.0.0.1:9090
curl -c cookies.txt -X POST http://127.0.0.1:9090/login \
-H "Content-Type: application/json" \
-d '{"username": "user1", "password": "pass1"}'
{"message":"Logged in successfully."}

curl -b cookies.txt -X POST http://127.0.0.1:9090/products \
-H "Content-Type: application/json" \
-d '{
"name": "Example Product",
"description": "A sample product for demonstration purposes.",
"price": 19.99
}'

http://127.0.0.1:9090/products
