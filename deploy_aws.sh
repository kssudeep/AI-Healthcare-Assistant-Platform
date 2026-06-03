#!/bin/bash
AWS_REGION="us-east-1"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REPO="healthcare-ai-platform"
IMAGE_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest"
CLUSTER_NAME="healthcare-cluster"

aws ecr create-repository --repository-name ${ECR_REPO} --region ${AWS_REGION} || true

aws ecr get-login-password --region ${AWS_REGION} |   docker login --username AWS --password-stdin   ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

docker build -t ${ECR_REPO} .
docker tag ${ECR_REPO}:latest ${IMAGE_URI}
docker push ${IMAGE_URI}

aws ecs create-cluster --cluster-name ${CLUSTER_NAME} --region ${AWS_REGION} || true

echo "Deployment configured. Complete setup in AWS Console."
