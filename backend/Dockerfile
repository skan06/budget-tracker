# Stage 1: Build and Package
FROM maven:3.9.11 AS builder

WORKDIR /app

# Copy pom.xml and download dependencies
COPY backend/pom.xml .

RUN mvn dependency:go-offline

# Copy source code
COPY backend/src ./src

# Build the JAR
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM openjdk:17-jdk-slim

WORKDIR /app

# Correct path: JAR is in /app/target, not /app/backend/target
COPY --from=builder /app/target/budget-tracker-backend-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8081

ENTRYPOINT ["java", "-jar", "app.jar"]