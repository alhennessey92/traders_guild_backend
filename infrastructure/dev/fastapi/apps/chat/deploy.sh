#!/bin/bash

# Set repo variables
REPO="ghcr.io/alhennessey92/tg-fastapi-chat"
DEPLOYMENT_FILE="k8s/deployment.yaml"  # Adjust if your deployment file lives elsewhere

# Generate a unique tag using timestamp
TAG=$(date +%s)

echo "🚀 Building image: $REPO:$TAG"
docker build -t $REPO:$TAG .

echo "📤 Pushing image to GHCR"
docker push $REPO:$TAG

echo "📝 Updating deployment.yaml with new image tag..."
sed -i '' "s|image: $REPO:.*|image: $REPO:$TAG|" $DEPLOYMENT_FILE



echo "✅ Done!al New image $TAG pushed and deployment.yaml updated. ArgoCD will sync this automatically."