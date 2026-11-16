# Frontend image
Build from repository root: `docker build -f Docker-app/Dockerfile -t smart-grocery-frontend:local .`. Nginx serves the Vite build and proxies `/api` to the backend service.
