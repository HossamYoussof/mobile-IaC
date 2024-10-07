#!/bin/bash

# Check if Docker is installed
if ! [ -x "$(command -v docker)" ]; then
  echo 'Error: docker is not installed.' >&2
  exit 1
fi

# Check if Docker Compose is installed
if ! [ -x "$(command -v docker-compose)" ]; then
  echo 'Error: docker-compose is not installed.' >&2
  exit 1
fi

# Create the necessary directories for Jenkins
echo "Creating Jenkins home directory..."
mkdir -p jenkins_home

# Create the Docker Compose file
echo "Creating docker-compose.yml file..."
cat <<EOL > docker-compose.yml

services:
  jenkins:
    image: jenkins/jenkins:latest-jdk21
    container_name: jenkins
    ports:
      - "8080:8080"
      - "50000:50000"
    restart: always
    volumes:
      - jenkins_home:/var/jenkins_home
    networks:
      - ci_network

  sonarqube:
    image: sonarqube:lts-community
    container_name: sonarqube
    ports:
      - "9000:9000"
    restart: always
    environment:
      - SONAR_JDBC_URL=jdbc:postgresql://db:5432/sonar
      - SONAR_JDBC_USERNAME=sonar
      - SONAR_JDBC_PASSWORD=sonar
    networks:
      - ci_network
    depends_on:
      - db

  db:
    image: postgres:13
    container_name: postgres
    environment:
      - POSTGRES_USER=sonar
      - POSTGRES_PASSWORD=sonar
      - POSTGRES_DB=sonar
    networks:
      - ci_network

volumes:
  jenkins_home:

networks:
  ci_network:
    driver: bridge
EOL

# Start the services with Docker Compose
echo "Starting Jenkins and SonarQube containers using Docker Compose..."
docker-compose up -d

# Output the status of the containers
docker-compose ps

echo ""
echo "Jenkins is available at http://localhost:8080"
echo "SonarQube is available at http://localhost:9000"
echo "PostgreSQL is running as the database for SonarQube."