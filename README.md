# Mobile CI/CD Infrastructure

This repository contains Infrastructure as Code for setting up a comprehensive mobile CI/CD environment.

## Components
- Jenkins CI/CD server with pre-configured jobs
- Android build environment
- iOS build environment
- SonarQube for code quality
- Nexus for artifact repository

## Quick Start
1. Clone this repository
2. Run `chmod +x setup.sh`
3. Run `./setup.sh`
4. Access Jenkins at http://localhost:8080

## Requirements
- Docker and Docker Compose
- macOS host for iOS builds

## Configuration
Edit the following files to customize your setup:
- `docker-compose.yml` - Infrastructure components
- `jenkins/plugins.txt` - Jenkins plugins
- `jenkins/casc/jenkins.yaml` - Jenkins configuration
- `jenkins/casc/seed-job.groovy` - Jenkins job definitions
