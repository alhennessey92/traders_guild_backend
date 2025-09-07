#!/bin/bash
set -e



echo "📦 Deploying Redis Simple resources ..."

# Apply namespace first
kubectl apply -f namespace.yaml





# Apply ArgoCD Application
kubectl apply -f argocd-app.yaml

echo "✅ Redis Simple deployment applied successfully!"