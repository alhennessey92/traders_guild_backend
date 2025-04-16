#!/bin/bash

# === CONFIG ===
IMAGE_NAME="ghcr.io/alhennessey92/fastapi-test"
TAG=$(date +%s)


# # === LOGIN ===
# echo "🔐 Logging in to GitHub Container Registry..."
# echo $GITHUB_PAT | docker login ghcr.io -u $GITHUB_USER --password-stdin

# === BUILD ===
echo "🐳 Building Docker image..."
docker build -t $IMAGE_NAME:$TAG .

# === PUSH ===
echo "📦 Pushing image to GHCR..."
docker push $IMAGE_NAME:$TAG



echo "✅ Done!"