# Deployment guide

## Docker
Set `.env` from `.env.example` and replace the password. Run `docker compose -f compose.yml up --build -d`; inspect `docker compose ps` and logs. Persistent PostgreSQL data is held in `postgres_data`.

## CI/CD: Jenkins + Argo CD
There is deliberately no Jenkinsfile in this repository because the project owner will author the Jenkins pipeline. Jenkins is responsible for CI and image publishing only:
1. Checkout the application source.
2. Run Maven tests/package and the frontend production build.
3. Build backend and frontend Docker images with immutable tags (for example, build number plus short Git SHA).
4. Push both images to the configured registry using Jenkins credentials.
5. Update the image tags in the GitOps repository and commit/push that change.

Do not deploy with `kubectl apply` from Jenkins. Argo CD provides CD by watching the GitOps repository and reconciling the manifests into Kubernetes. The starter Argo CD Application is `argocd/smart-grocery-application.yaml`; replace its `repoURL` and confirm the branch/path. It watches `manifests/` and deploys into `smart-grocery`.

Install Argo CD in the target cluster using the official installation instructions for your chosen version, ensure it can access the Git repository, then register the Application:
```bash
kubectl apply -f argocd/smart-grocery-application.yaml
argocd app get smart-grocery
argocd app sync smart-grocery
argocd app wait smart-grocery --health
```
For a private Git repository, configure repository credentials in Argo CD (not in the Application YAML). Jenkins credentials and Argo CD repository credentials are separate. Do not store tokens, kubeconfigs or passwords in Git.

## Kubernetes prerequisites
Install a NetworkPolicy-capable CNI (e.g. Calico), AWS EBS CSI, metrics-server and ingress-nginx. Replace Secret placeholders, `REPLACE_ME` image paths and `grocery.example.com`; create TLS secret or configure cert-manager. For manual bootstrap/testing only, apply with `kubectl apply -f manifests/` and verify `kubectl get pods,svc,pvc,hpa,ingress -n smart-grocery`. During normal GitOps operation, let Argo CD apply changes. `kubectl port-forward svc/frontend 8081:80 -n smart-grocery` exposes a local test endpoint at http://localhost:8081.

## kOps
Use `kops validate cluster`, `kubectl get nodes`, `kubectl top nodes`, `kubectl get storageclass`, and verify EBS CSI and CNI before deploying. Cluster provisioning is separate from application delivery.

## Rollback and troubleshooting
Prefer reverting the Git commit that changed the image tag or manifests; Argo CD will reconcile the previous desired state. `./k8s/rollback.sh` is available for emergency/manual rollout rollback, but a Git revert is the preferred GitOps rollback. For pending PVCs check CSI driver, IAM and AZ placement. For HPA `unknown` metrics check metrics-server. For blocked traffic inspect NetworkPolicies and CNI enforcement. For Ingress 404/502 inspect controller, service endpoints and DNS. Do not delete the PostgreSQL PVC to troubleshoot application pods.
