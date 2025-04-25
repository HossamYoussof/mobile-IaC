#!/bin/bash

# Colors for terminal output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Mobile CI/CD Setup Script${NC}"
echo -e "${GREEN}========================================${NC}"

# Check for Docker and Docker Compose
if ! command -v docker &> /dev/null; then
  echo -e "${RED}Error: Docker is not installed.${NC}"
  echo "Please install Docker first and run this script again."
  exit 1
fi

if ! command -v docker-compose &> /dev/null; then
  echo -e "${RED}Error: Docker Compose is not installed.${NC}"
  echo "Please install Docker Compose first and run this script again."
  exit 1
fi

# Create projects directory if it doesn't exist
mkdir -p projects

# Configure environment
setup_environment() {
  echo -e "${YELLOW}Setting up CI/CD environment...${NC}"
  
  # Export the Docker build argument for the plugins file
  export PLUGINS_FILE="configs/plugins.txt" 
  
  echo -e "${YELLOW}Starting CI/CD environment...${NC}"
  docker-compose up -d --build
  
  echo -e "${GREEN}Setup complete!${NC}"
  echo "Jenkins: http://localhost:8080 (admin/admin)"
  echo "Nexus: http://localhost:8081"
  echo "SonarQube: http://localhost:9000 (admin/admin)"
}

# Remove Docker data function
remove_docker_data() {
  echo -e "${RED}WARNING: This will remove all Docker volumes for this project.${NC}"
  echo -e "${RED}All data including Jenkins configurations, build history, SonarQube data, and Nexus repositories will be lost.${NC}"
  echo -n "Are you sure you want to continue? (y/N): "
  read confirm
  
  if [[ $confirm == "y" || $confirm == "Y" ]]; then
    echo -e "${YELLOW}Stopping containers...${NC}"
    docker-compose down
    
    echo -e "${YELLOW}Removing Docker volumes...${NC}"
    docker volume rm jenkins_home android_sdk nexus-data sonarqube_data sonarqube_logs sonarqube_extensions 2>/dev/null || true
    
    echo -e "${GREEN}Docker volumes removed successfully.${NC}"
    echo "You can now restart the environment with a clean state."
  else
    echo -e "${YELLOW}Operation cancelled.${NC}"
  fi
}

# List Docker volumes
list_docker_volumes() {
  echo -e "${YELLOW}Listing Docker volumes for this project:${NC}"
  docker volume ls --filter name=jenkins_home
  docker volume ls --filter name=android_sdk
  docker volume ls --filter name=nexus-data
  docker volume ls --filter name=sonarqube_data
  docker volume ls --filter name=sonarqube_logs
  docker volume ls --filter name=sonarqube_extensions
}

# Main menu function
show_menu() {
  echo -e "${GREEN}========================================${NC}"
  echo -e "${GREEN}Mobile CI/CD Environment Setup${NC}"
  echo -e "${GREEN}========================================${NC}"
  echo "1) Setup environment"
  echo "2) Rebuild Jenkins container only"
  echo "3) Start/restart environment"
  echo "4) Stop environment"
  echo "5) View Jenkins logs"
  echo "6) Shell into Jenkins container"
  echo "7) List Docker volumes"
  echo "8) Remove Docker data (reset environment)"
  echo "9) Exit"
  echo -e "${GREEN}========================================${NC}"
  echo -n "Please enter your choice: "
}

# Main program logic
while true; do
  show_menu
  read choice
  
  case $choice in
    1)
      setup_environment
      ;;
    2)
      select_plugin_config
      export PLUGINS_FILE
      docker-compose up -d --build jenkins
      echo -e "${GREEN}Jenkins container rebuilt${NC}"
      ;;
    3)
      docker-compose up -d
      echo -e "${GREEN}Environment started${NC}"
      ;;
    4)
      docker-compose down
      echo -e "${GREEN}Environment stopped${NC}"
      ;;
    5)
      echo -e "${YELLOW}Jenkins logs (Ctrl+C to exit):${NC}"
      docker-compose logs -f jenkins
      ;;
    6)
      docker exec -it mobile-cicd-jenkins bash
      ;;
    7)
      list_docker_volumes
      ;;
    8)
      remove_docker_data
      ;;
    9)
      echo -e "${GREEN}Exiting. Goodbye!${NC}"
      exit 0
      ;;
    *)
      echo -e "${RED}Invalid option. Please try again.${NC}"
      ;;
  esac
  
  echo
  echo -e "${YELLOW}Press Enter to continue...${NC}"
  read
  clear
done
