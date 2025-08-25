FROM maven:3.9.9-eclipse-temurin-21-jammy AS build
WORKDIR /app
RUN apt-get update && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:21-jdk-jammy
COPY --from=build /app/target/configserver-*.jar app.jar
EXPOSE 8888
ENTRYPOINT ["java", "-jar", "app.jar"]