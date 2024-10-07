# Mobile Infrastructure as Code (IaC)
This repository provides a solution for setting up a Jenkins CI/CD environment with dedicated iOS and Android build nodes. The Jenkins master runs in a Docker container, Sonarqube runs in a Docker container while the iOS node and the Android node run on your local machine . Both nodes are connected to Jenkins using the Jenkins Swarm Plugin, which simplifies the process of adding build agents (nodes) to Jenkins.

## Setup Instructions
1. Downoad [docker](https://www.docker.com/products/docker-desktop/) and [docker compose](https://docs.docker.com/compose/install/)

2. Clone the Repository
Start by cloning this repository to your local machine:

```sh
git clone https://github.com/HossamYoussof/mobile-IaC.git
cd mobile-IaC
```

2. Set Up Jenkins Master
- Execute run_ci_cd.sh script

```sh
./run_ci_cd.sh
```

- Access Jenkins
Open Jenkins in your browser at http://localhost:8080.
During the initial setup, Jenkins will prompt you for an admin password. You can locate this password by running:

docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
After logging in, you can install the recommended plugins and create your first admin user.

- Install [Swarm plugin](https://plugins.jenkins.io/swarm/)

3. Set Up iOS Node (macOS)
- Add your <JENKINS_USER> and <JENKINS_PASSWORD> in ios-node.sh script
- Execute ios-node.sh script

```sh
./ios-node.sh
```

3. Set Up Android Node (linux)
- Add your <JENKINS_USER> and <JENKINS_PASSWORD> in android-node.sh script
- Execute android-node.sh script

```sh
./android-node.sh
```

# Summary
Jenkins Master is running in a Docker container.
Android Node runs in its own Docker container and is automatically registered with Jenkins using the Swarm Plugin.
iOS Node runs on a macOS machine and is also connected to Jenkins using the Swarm Plugin.
The Swarm Plugin makes it easier to manage build nodes by allowing them to self-register with Jenkins.
This setup is ideal for teams working on both iOS and Android applications and looking for an automated way to build and test their apps using Jenkins.

# Troubleshooting
If the iOS or Android node does not appear in Jenkins, ensure that:
The Swarm client is running on the agent (macOS for iOS, Docker for Android).
The Jenkins URL, username, and password are correct.
The macOS machine has the necessary tools installed (Xcode, Java).
For any issues with Docker, make sure Docker and Docker Compose are installed and running properly.

# License
This project is licensed under the MIT License. See the LICENSE file for details.