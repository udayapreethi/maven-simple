# ===========================
# Stage 1: Build the project
# ===========================
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy pom.xml to install dependencies
COPY /c/DevOps/Maven-simple/maven-simple/pom.xml
RUN mvn dependency:go-offline

# Copy all Java source files
COPY C:/DevOps/Maven-simple/maven-simple/src/main/java/com/github/jitpack/"App.java WebApp.java"

# Build the JAR file (skip tests for faster build)
RUN mvn clean package -DskipTests


# ===========================
# Stage 2: Run the app
# ===========================
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy only the built JAR file from the previous stage
COPY C:/DevOps/Maven-simple/maven-simple/target/maven-simple-0.2-SNAPSHOT.jar app.jar

# Expose the same port as in WebApp.java 
EXPOSE 8083

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
