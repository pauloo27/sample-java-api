# SAMPLE JAVA API

Minimal Spring Boot Web API made with Java 25, Gradle and Docker.

## How to run locally

For simplicity, you can run the application locally using Docker by running:

```
docker compose up -d --build
```

Once the service is running, access http://localhost:8080/health.

## Configuration

You can change the port Spring Boot listens to by setting the `SERVER_PORT` environment variable in `docker-compose.yml`:

```yaml
environment:
  - SERVER_PORT=9000
```

Make sure to also update the port mapping accordingly.
