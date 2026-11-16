#!/usr/bin/env bash
set -euo pipefail
kubectl rollout undo deployment/backend -n smart-grocery
kubectl rollout undo deployment/frontend -n smart-grocery
