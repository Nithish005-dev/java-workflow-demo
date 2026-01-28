# Build stage: use Maven + JDK
FROM maven:3.9.6-eclipse-temurin-17 AS build
 
WORKDIR /app
 
# Copy pom.xml first to cache dependencies
COPY pom.xml .
 
# Download dependencies
RUN mvn dependency:go-offline
 
# Copy source code
COPY src ./src
 
# Build the project
RUN mvn clean package
 
# Run stage: lightweight JRE
FROM eclipse-temurin:17-jre
 
WORKDIR /app
 
# Copy JAR from build stage
COPY --from=build /app/target/java-demo-1.0.jar app.jar
 
# Run the app
CMD ["java", "-jar", "app.jar"]
