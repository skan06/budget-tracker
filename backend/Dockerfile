# Stage 1: Build and Package
FROM maven:3.9.11-openjdk-17 AS builder

WORKDIR /app

# Copy pom.xml and download dependencies (for caching)
COPY backend/pom.xml .

# Download dependencies first (cached if pom.xml doesn't change)
RUN mvn dependency:go-offline

# Copy the rest of the source code
COPY backend/src ./src

# Build the JAR file
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM openjdk:17-jdk-slim

WORKDIR /app

# ✅ Copy the JAR from the builder stage (with correct path)
COPY --from=builder /app/backend/target/budget-tracker-backend-0.0.1-SNAPSHOT.jar app.jar

# Expose port 8081
EXPOSE 8081

# Run the Spring Boot app
ENTRYPOINT ["java", "-jar", "app.jar"]