#!/bin/bash

# Change this if you have TLS + domain configured
KONG_HOST="http://localhost:31431"

echo "🔹 Testing FastAPI via Kong..."

# GET /v1/test/ping
echo "➡️ GET /v1/test/ping"
curl -i "$KONG_HOST/v1/test/ping"
echo -e "\n"

# POST /v1/test/ping-post
echo "➡️ POST /v1/test/ping-post"
curl -i -X POST "$KONG_HOST/v1/test/ping-post" \
  -H "Content-Type: application/json" \
  -d '{"content": "Hello from outside the cluster!"}'
echo -e "\n"