#!/bin/bash

set -e

echo "📦 Installing Kong Ingress Controller CRDs (v2.48.0)..."

CRD_VERSION="2.48.0"
CRD_BASE_URL="https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/$CRD_VERSION/config/crd/"

CRDS=(
  configuration.konghq.com_kongconsumers.yaml
  configuration.konghq.com_kongcredentials.yaml
  configuration.konghq.com_kongingresses.yaml
  configuration.konghq.com_kongplugins.yaml
  configuration.konghq.com_tcpingresses.yaml
  configuration.konghq.com_udpingresses.yaml
  configuration.konghq.com_kongclusterplugins.yaml
)

for crd in "${CRDS[@]}"; do
  echo "➡️ Applying $crd"
  kubectl apply -f "${CRD_BASE_URL}${crd}"
done

echo "✅ Kong CRDs installed."