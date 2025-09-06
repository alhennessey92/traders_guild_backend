#!/bin/bash

set -e

echo "Applying all ArgoCD Application manifests..."

find . -name 'argocd-app.yaml' -print0 | while IFS= read -r -d '' file; do
    echo "Applying $file"
    kubectl apply -f "$file"
done

echo "All ArgoCD Application manifests applied."