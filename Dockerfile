# Official Gradle image for building
FROM docker.io/gradle:9.2.1-jdk25 AS builder

WORKDIR /app

COPY gradle/ gradle/
COPY gradlew gradlew.bat settings.gradle build.gradle ./

RUN ./gradlew dependencies --no-daemon

COPY src/ src/

RUN ./gradlew build --no-daemon

# Lightweight JRE for runner
FROM docker.io/eclipse-temurin:25-jre

WORKDIR /app

COPY --from=builder /app/build/libs/*.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
