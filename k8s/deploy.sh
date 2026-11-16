#!/usr/bin/env bash
set -euo pipefail
kubectl apply -f manifests/01-namespace.yaml
kubectl apply -f manifests/
kubectl rollout status statefulset/postgres -n smart-grocery --timeout=180s
kubectl rollout status deployment/backend -n smart-grocery --timeout=240s
kubectl rollout status deployment/frontend -n smart-grocery --timeout=180s
