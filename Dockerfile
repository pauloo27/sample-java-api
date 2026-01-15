# Official Gradle image for building
FROM docker.io/gradle:9.2.1-jdk25 AS builder

WORKDIR /app

COPY settings.gradle build.gradle ./

RUN gradle dependencies --no-daemon

COPY src/ src/

RUN gradle build --no-daemon

# Lightweight JRE for runner
FROM docker.io/eclipse-temurin:25-jre

WORKDIR /app

COPY --from=builder /app/build/libs/*.jar app.jar

CMD ["java", "-jar", "app.jar"]
