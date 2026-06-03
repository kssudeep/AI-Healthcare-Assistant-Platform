#!/bin/bash
PROJECT_ID="your-gcp-project-id"
SERVICE_NAME="healthcare-ai-platform"
REGION="us-central1"
IMAGE="gcr.io/${PROJECT_ID}/${SERVICE_NAME}"

gcloud auth login
gcloud config set project ${PROJECT_ID}
gcloud services enable cloudbuild.googleapis.com run.googleapis.com
gcloud builds submit --tag ${IMAGE} .
gcloud run deploy ${SERVICE_NAME}   --image ${IMAGE}   --platform managed   --region ${REGION}   --allow-unauthenticated   --memory 2Gi   --cpu 2   --timeout 300   --port 8000

gcloud run services describe ${SERVICE_NAME}   --region ${REGION}   --format 'value(status.url)'
