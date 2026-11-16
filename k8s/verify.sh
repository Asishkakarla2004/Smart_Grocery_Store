#!/usr/bin/env bash
set -euo pipefail
kubectl get pods,svc,pvc,hpa,ingress -n smart-grocery
kubectl rollout status deployment/backend -n smart-grocery
kubectl rollout status deployment/frontend -n smart-grocery
kubectl get --raw /apis/metrics.k8s.io/v1beta1/nodes >/dev/null && echo 'Metrics API available' || echo 'Metrics API unavailable'
