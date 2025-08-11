# Use a slim, official OpenJDK 17 image (optimized for production)
FROM openjdk:17-jdk-slim

# Metadata labels
LABEL maintainer="skander.houidi06@gmail.com"
LABEL org.opencontainers.image.source="https://github.com/skan06/budget-tracker"

# Set working directory inside the container
WORKDIR /app

# Copy the built JAR file (produced by Maven) into the container
# Jenkins will run `mvn clean package` first, so this file will exist
COPY target/budget-tracker-backend-0.0.1-SNAPSHOT.jar app.jar

# Optional: Change file permissions (good for security)
RUN chmod 400 app.jar

# Expose the port the app runs on
EXPOSE 8081

# Run the Spring Boot application
# Use `java -jar` with security and memory options
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "app.jar"]