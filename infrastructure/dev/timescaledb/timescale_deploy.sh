#!/bin/bash
set -e

# Folder containing your TimescaleDB YAMLs
TIMESCALE_DIR=""   # Adjust this path if different

echo "📦 Deploying TimescaleDB resources ..."

# Apply namespace first
kubectl apply -f namespace.yaml

# Apply secret
kubectl apply -f timescaledb-secret.yaml

# Apply PVC
kubectl apply -f timescaledb-pvc.yaml

# Apply StatefulSet
kubectl apply -f timescaledb-statefulset.yaml

# Apply Service
kubectl apply -f timescaledb-service.yaml

# Apply ArgoCD Application
kubectl apply -f argocd-app.yaml

# Need to deplot schema, or find out once the db has been deployed

echo "✅ TimescaleDB deployment applied successfully!"