# ===========================
# Stage 1: Build the project
# ===========================
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy all Java source files (the entire src folder)
COPY src ./src

# Build the JAR file (skip tests for faster build)
RUN mvn clean package -DskipTests


# ===========================
# Stage 2: Run the app
# ===========================
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy the built JAR file from previous stage
COPY --from=build /app/target/maven-simple-0.2-SNAPSHOT.jar app.jar

# Expose the same port as your WebApp.java
EXPOSE 8083

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
