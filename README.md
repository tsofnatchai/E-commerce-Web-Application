project/
├── terraform/
│   ├── backend.tf                # Remote state (S3/DynamoDB) configuration
│   ├── main.tf                   # Root module calling all child modules
│   ├── variables.tf              # Root variables
│   ├── outputs.tf                # Root outputs
│   └── modules/
│         ├── vpc/                # VPC, subnets, routing, NAT gateway, etc.
│         │     ├── main.tf
│         │     ├── variables.tf
│         │     └── outputs.tf
│         ├── eks/                # EKS cluster with worker nodes (IRSA)
│         │     ├── main.tf
│         │     ├── variables.tf
│         │     └── outputs.tf
│         ├── kinesis/            # Kinesis stream & Firehose (for order events)
│         │     ├── main.tf
│         │     ├── variables.tf
│         │     └── outputs.tf
│         ├── rds/                # RDS MySQL (Multi-AZ) instance
│         │     ├── main.tf
│         │     ├── variables.tf
│         │     └── outputs.tf
│         ├── elasticsearch/      # Elasticsearch/OpenSearch domain for full‑text search
│         │     ├── main.tf
│         │     ├── variables.tf
│         │     └── outputs.tf
│         ├── iam/                # IAM roles, policies, and instance profiles for EC2/IRSA
│         │     ├── main.tf
│         │     ├── variables.tf
│         │     └── outputs.tf
│         └── security/           # Security groups and network ACLs
│               ├── main.tf
│               ├── variables.tf
│               └── outputs.tf
├── helm/
│   └── flask-app/                # Helm chart for deploying the Flask app on EKS
│         ├── Chart.yaml
│         ├── values.yaml
│         └── templates/
│               ├── deployment.yaml
│               ├── service.yaml
│               ├── hpa.yaml
│               └── vpa.yaml   # Optional (if you deploy a VPA operator)
├── flask-app/                    # Flask application source code
│   ├── app.py
│   └── requirements.txt
└── docs/
└── deployment_guide.md     # Documentation for deployment, scaling, security, etc.

Advanced Scalable E-commerce Web Application with Real-Time Streaming, Security, Autoscaling, and Helm on AWS

A Flask e‑commerce web application (with basic user authentication, product catalog management with Elasticsearch integration, and real‑time order tracking via AWS Kinesis).

Overview
Deployment of the Flask app on an EKS cluster using Helm (with HPA/VPA and persistent storage via EBS).
All AWS infrastructure (EKS cluster, VPC, S3, DynamoDB for state, RDS, Elasticsearch/OpenSearch, IAM roles for IRSA, security groups, and Kinesis) provisioned by Terraform using modular code.

deployment guide:

Terraform Deployment:
Run terraform init in the terraform/ directory.
Run terraform plan to review changes.
Run terraform apply to provision AWS resources.
Helm Deployment:
Configure your kubeconfig to point to the EKS cluster (using aws eks update-kubeconfig --name <cluster_name> --region <region>).
In the helm/flask-app/ directory, run helm install flask-app . --namespace your-namespace (create the namespace if needed).
Verification:
Use AWS Console to verify resource creation (VPC, EKS, ALB, RDS, etc.).
Use kubectl get pods,svc to see the Flask app pods and service.
Check logs and monitor HPA/VPA behavior.
Summary
   Terraform Modules:
   Provision your AWS infrastructure (VPC, EKS, Kinesis, RDS, Elasticsearch, IAM, and security) via modular Terraform code.
   Helm:
   Deploy the Flask application into your EKS cluster using a custom Helm chart that includes autoscaling (HPA/VPA).
   Flask App:
   A minimal Flask e-commerce application that integrates with AWS services (e.g., Kinesis for real‑time order events).
   Manual Setup:
   Pre-create your S3 bucket for Terraform state and a DynamoDB table for locking. Install AWS CLI, kubectl, Helm, and Terraform.


Prerequisite:

on AWS CLI:

I created S3 bucket in AWS:
aws s3api create-bucket --bucket terraform-state-bucket-tsofnat --region us-east-1
and added it permission->policy:
{
"Version": "2012-10-17",
"Statement": [
{
"Sid": "AllowELBAccessLogs",
"Effect": "Allow",
"Principal": {
"Service": "elasticloadbalancing.amazonaws.com"
},
"Action": [
"s3:ListBucket",
"s3:GetObject",
"s3:PutObject"
],
"Resource": [
"arn:aws:s3:::terraform-state-bucket-tsofnat",
"arn:aws:s3:::terraform-state-bucket-tsofnat/*"
]
}
]
}

create dynamo db table in AWS:
aws dynamodb create-table --table-name terraform-locking-user-tsofnat --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1


Order of Steps
Prepare Remote State:
Ensure your DynamoDB table (terraform-locking-user-tsofnat) and the S3 state bucket (terraform-state-bucket-tsofnat) exist. Configure your backend.tf accordingly.

Provision AWS Infrastructure with Terraform:
Run in your project root:

bash

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

removed hpa, vpa - didn't work

Monitor Real-time Data:
Your Flask app should send order events to the Kinesis stream. Kinesis Firehose delivers data to your S3 bucket (and optionally to Elasticsearch for analytics). Verify logs in S3 and monitor your Elasticsearch index.

Secure Your Kubernetes Cluster:
Ensure you configure RBAC, Network Policies, and TLS (via AWS ACM) as required for production.