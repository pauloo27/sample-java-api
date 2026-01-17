 Sample Java API

A minimal Spring Boot application that provides a single health check endpoint.
Built with Java 25, Gradle, and deployed to Kubernetes using automated CI/CD pipelines.

## How It Works

This is a Spring Boot 4.0.1 web application with one REST controller:

- **GET /health** - Returns health status as JSON: `{"status": "UP"}`

The Dockerfile uses a multi-stage build:
1. **Builder stage** - Gradle 9.2.1 with JDK 25 compiles the application
2. **Runtime stage** - Eclipse Temurin 25 JRE runs the JAR (lightweight final image)

## CI/CD 

The CI/CD workflows automatically build, test, and deploy:

- **PR Checks** - Gradle build and tests run on every pull request
- **Build & Deploy** - On push to main, builds Docker image 
  (tagged with commit SHA) and deploys to dev environment
- **Promote to Prod** - Manual workflow to deploy a specific image tag to 
  production

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `SERVER_PORT` | `8080` | HTTP port for the Spring Boot application |

When deployed via Helm, the port is configured through values files 
(`helm/values.dev.yml` or `helm/values.prod.yml`) using the `http_port`
parameter.

## How to Use Locally

### With Docker Compose

```bash
docker compose up -d --build
```

Access the health endpoint at http://localhost:8080/health.

To change the port, edit `docker-compose.yml`:

```yaml
environment:
  - SERVER_PORT=9000
ports:
  - 9000:9000
```

## Integration with Other Repos

### Consumes from

**deployment-workflows**
- Calls `docker-build-push.yml` to build multi-arch (amd64/arm64) Docker images 
  and push to GitHub Container Registry (GHCR)
- Calls `helm-install.yml` to deploy to Kubernetes via OpenVPN connection with 
  kubectl

**helm-charts**
- Uses Helm chart `oci://ghcr.io/pauloo27/helm-charts/sample-java-api:v0.1.1` 
  for Kubernetes deployments
- Environment-specific configuration:
  - `helm/values.dev.yml` - Dev namespace (port 8080, 512Mi memory limit)
  - `helm/values.prod.yml` - Prod namespace (port 8000, 1Gi memory limit)

### Provides to

**Docker Registry (GHCR)**
- Pushes images to `ghcr.io/pauloo27/sample-java-api`
- Tags images with first 7 characters of commit SHA (e.g., `abc1234`)
- Multi-architecture manifest supports both amd64 and arm64

## Assumptions and Shortcuts

- **Commit SHA tagging**: Uses abbreviated commit SHA instead of semantic 
  versioning for simplicity in a demo context
- **Java 25 & Spring Boot 4**: Uses modern Java and Spring Boot for simplicity
- **Environment parity**: Dev and prod run on the same K8s cluster (different
  namespaces), differing only in port number and resource limits
