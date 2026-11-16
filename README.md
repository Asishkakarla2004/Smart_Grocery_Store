# Smart Grocery Store & Inventory Management System

A grocery storefront and shop-owner inventory workspace built with React/Vite, Java 21/Spring Boot, PostgreSQL 16 and Docker/Kubernetes deployment assets.

## Features in this build
- Customer and owner views with role switcher; catalogue search/category filters, cart and order placement (interactive frontend demo state).
- Owner dashboard, sales overview, inventory quick adjustment, product creation, low-stock alerts, supplier directory, settings and reports.
- Spring Boot REST API for product CRUD, inventory adjustments, orders and health; Flyway relational schema.
- Docker Compose, multi-stage backend/frontend images, 12 Kubernetes manifests and an Argo CD Application definition.

## Run the UI locally
```bash
cd frontend
npm install
npm run dev
```
Open http://localhost:5173. The dashboard currently uses seeded demo data in browser state. It is not yet wired to persist every screen action through the backend.

## Run the backend
Requires Java 21, Maven and PostgreSQL 16. Create `smart_grocery_db`, set `SPRING_DATASOURCE_URL`, `SPRING_DATASOURCE_USERNAME`, `SPRING_DATASOURCE_PASSWORD`, then run `mvn spring-boot:run`. Swagger: `/swagger-ui/index.html`; health: `/actuator/health`; API health: `/api/v1/health`.

## Docker Compose
Copy `.env.example` to `.env`, set a strong `POSTGRES_PASSWORD`, then:
```bash
docker compose -f compose.yml up --build -d
docker compose -f compose.yml ps
docker compose -f compose.yml logs -f
docker compose -f compose.yml down
```
Frontend http://localhost:3000, backend http://localhost:8080, Swagger http://localhost:8080/swagger-ui/index.html, PostgreSQL localhost:5432.

## CI/CD design: Jenkins + Argo CD
This repository intentionally does **not** include a Jenkinsfile: you will author and maintain your own Jenkins pipeline. Jenkins is the CI system and should checkout, build/test, build Docker images, push versioned images to your registry, and commit the new image tag to the GitOps repository (or update the deployment manifests in this repository if you use a single-repo GitOps model). Jenkins should not run `kubectl apply` or perform the Kubernetes deployment.

Argo CD is responsible for CD. It watches the GitOps repository and synchronizes the Kubernetes manifests to the cluster. Update `argocd/smart-grocery-application.yaml` with your Git repository URL, install/configure Argo CD in the cluster, then register the Application:
```bash
kubectl apply -f argocd/smart-grocery-application.yaml
argocd app get smart-grocery
argocd app sync smart-grocery
```
The Application watches the `manifests/` directory on branch `main`, targets namespace `smart-grocery`, and enables automated sync, pruning and self-healing. Keep the Argo CD Application definition outside the watched `manifests/` path to avoid an application self-management loop.

## Kubernetes / kOps
Review and replace image references and Secret values, install EBS CSI, metrics-server, ingress-nginx and a policy-enforcing CNI. For a manual bootstrap/test deployment only, run `./k8s/deploy.sh`; normal ongoing deployment should be performed by Argo CD. See `DEPLOYMENT.md`, `k8s/README.md` and `kops/README.md`. DNS/TLS are environment-specific and are not pre-provisioned.

## Current implementation boundaries
This is a runnable project foundation, not a claim of fully production-accepted software. JWT issuance/login, full RBAC, order-item reservation/deduction workflow, real supplier persistence, image storage, AI product recognition, Telugu/English speech provider, comprehensive integration tests and cloud deployment still require implementation/configuration. The supplied UI demonstrates customer and owner flows with local seeded state. Do not use demo data for real transactions.
