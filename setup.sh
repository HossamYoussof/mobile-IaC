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

# Create directories
mkdir -p projects
mkdir -p jenkins/casc

# Choose Jenkins plugin configuration
select_plugin_config() {
  echo -e "${YELLOW}Select Jenkins plugin configuration:${NC}"
  echo "1) Minimal (recommended for troubleshooting)"
  echo "2) Core plugins"
  echo "3) Mobile-specific plugins"
  echo "4) Full plugin set"
  echo -n "Enter choice (1-4): "
  read plugin_choice
  
  case $plugin_choice in
    1) cp configs/plugins-minimal.txt jenkins/plugins.txt ;;
    2) cp configs/plugins-core.txt jenkins/plugins.txt ;;
    3) cp configs/plugins-mobile.txt jenkins/plugins.txt ;;
    4) cp configs/plugins-full.txt jenkins/plugins.txt ;;
    *) echo -e "${RED}Invalid choice, using minimal plugins${NC}"
       cp configs/plugins-minimal.txt jenkins/plugins.txt ;;
  esac
}

# Configure environment
setup_environment() {
  echo -e "${YELLOW}Setting up CI/CD environment...${NC}"
  
  # Copy configuration files
  cp configs/Dockerfile jenkins/
  cp configs/jenkins.yaml jenkins/casc/
  cp configs/docker-compose.yml ./
  
  # Select plugin configuration
  select_plugin_config
  
  echo -e "${YELLOW}Starting CI/CD environment...${NC}"
  docker-compose up -d --build
  
  echo -e "${GREEN}Setup complete!${NC}"
  echo "Jenkins: http://localhost:8080 (admin/admin)"
  echo "Nexus: http://localhost:8081"
  echo "SonarQube: http://localhost:9000 (admin/admin)"
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
  echo "7) Exit"
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
