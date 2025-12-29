#!/bin/bash
set -e

# List of deploy scripts to run (adjust paths if needed)
DEPLOY_SCRIPTS=(
  "chart/deploy.sh"
  "main/deploy.sh"
  # Add more apps here
)

echo "🚀 Starting deployment of all apps..."

for script in "${DEPLOY_SCRIPTS[@]}"; do
  if [ -f "$script" ]; then
    echo "------------------------------------------------"
    echo "🔹 Running $script"
    bash "$script"
  else
    echo "⚠️  Script $script not found, skipping..."
  fi
done

echo "✅ All deploy scripts completed successfully."